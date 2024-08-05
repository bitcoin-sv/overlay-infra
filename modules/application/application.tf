resource "aws_s3_bucket" "codepipeline_bucket" {
  bucket = "${var.project_name}-codepipeline-bucket"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_ecr_repository" "overlay_example" {
  name = var.ecr_repo_name
}

resource "aws_iam_policy" "codebuild_policies" {
  name = "codebuild_policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "ecr:GetAuthorizationToken",
          "cloudformation:*",
          "ecs:*",
          "ec2:*",
          "s3:*",
          "ecr:*",
          "codebuild:*",
          "ssm:*",
          "secretsmanager:*",
          "cloudwatch:*",
          "elasticloadbalancing:*",
          "iam:*",
          "logs:*",
          "rds:*",
          "dynamodb:*",
          "codepipeline:*",
          "autoscaling:*",
          "application-autoscaling:*",
          "route53:*",
          "events:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["ecr:*"]
        Effect   = "Allow"
        Resource = [
          aws_ecr_repository.overlay_example.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role" "codebuild_service_role" {
  name = "codebuild-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = [aws_iam_policy.codebuild_policies.arn]
}

resource "aws_iam_policy_attachment" "codebuild_service_role_policy" {
  name        = "${var.ecr_repo_name}-codebuild-role"
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
  roles       = [aws_iam_role.codebuild_service_role.name]
}

resource "aws_codebuild_project" "overlay_example_build" {
  name          = "overlay-example-build"
  service_role  = aws_iam_role.codebuild_service_role.arn
  source {
    type            = "CODEPIPELINE"
    # location        = "https://github.com/bitcoin-sv/overlay-infra"
    # git_clone_depth = 1
    buildspec       = "modules/application/buildspec.yaml"
  }

  artifacts {
    type = "CODEPIPELINE"
    name = aws_s3_bucket.codepipeline_bucket.id
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = var.region
    }
    environment_variable {
      name  = "CLUSTER_NAME"
      value = var.cluster_name
    }
    environment_variable {
      name  = "ECR_REPO_URI"
      value = aws_ecr_repository.overlay_example.repository_url
    }
    
    environment_variable {
      name  = "DB_PORT"
      value = var.DB_PORT
    }
    environment_variable {
      name  = "DB_USER"
      value = var.DB_USER
    }
    environment_variable {
      name  = "DB_PASSWORD"
      value = var.DB_PASSWORD
    }
    environment_variable {
      name  = "DB_NAME"
      value = var.DB_NAME
    }
    environment_variable {
      name  = "DB_ENDPOINT"
      value = var.DB_ENDPOINT
    }

    environment_variable {
      name  = "S3_BUCKET"
      value = var.S3_BUCKET
    }
  }

  cache {
    type = "LOCAL"
    modes = ["LOCAL_SOURCE_CACHE", "LOCAL_DOCKER_LAYER_CACHE"]
  }
}

resource "aws_iam_policy" "granulated" {
  name = "policy-618033"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = [
          aws_s3_bucket.codepipeline_bucket.arn,
          "${aws_s3_bucket.codepipeline_bucket.arn}/*"
        ]
      },
    ]
  })
}

resource "aws_iam_policy" "all" {
  name = "policy-381966"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "codebuild:StartBuild", "codebuild:BatchGetBuilds",
          "cloudformation:*",
          "cloudwatch:*",
          "events:*",
          "iam:PassRole",
          "secretsmanager:*",
          "ec2:*",
          "kms:*",
          "ssm:*",
          "ecr:*",
          "ecs:*",
          "codestar-connections:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "codepipeline_service_role" {
  name = "codepipeline-service-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = [aws_iam_policy.granulated.arn, aws_iam_policy.all.arn]
}

resource "aws_iam_policy" "codepipeline_policy" {
  name   = "codepipeline-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "codestar-connections:UseConnection",
          "s3:PutObject",
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:ListBucket",
          "s3:DeleteObject"
        ],
        Resource = [
          aws_s3_bucket.codepipeline_bucket.arn,
          "${aws_s3_bucket.codepipeline_bucket.arn}/*",
          var.github_connection_arn
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "codepipeline_service_role_policy" {
  name        = "${var.ecr_repo_name}-codepipeline-role"
  policy_arn  = aws_iam_policy.codepipeline_policy.arn
  roles       = [aws_iam_role.codepipeline_service_role.name]
}

resource "aws_codepipeline" "overlay_example_pipeline" {
  name     = "overlay-example-pipeline"
  role_arn = aws_iam_role.codepipeline_service_role.arn

  artifact_store {
    type     = "S3"
    location = aws_s3_bucket.codepipeline_bucket.bucket
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = "bitcoin-sv/overlay-example"
        BranchName       = "master"
      }
    }
    action {
      name             = "Infra"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["infra_output"]
      configuration = {
        ConnectionArn    = var.github_connection_arn
        FullRepositoryId = "bitcoin-sv/overlay-infra"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "Build"
    action {
      version          = "1"
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output", "infra_output"]
      output_artifacts = ["build_output"]
      configuration = {
        ProjectName = aws_codebuild_project.overlay_example_build.name
        PrimarySource = "infra_output"
      }
    }
  }
}
