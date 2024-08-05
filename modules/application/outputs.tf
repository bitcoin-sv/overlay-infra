output "ecr_repository_url" {
  value = aws_ecr_repository.overlay_example.repository_url
}

output "codebuild_project_name" {
  value = aws_codebuild_project.overlay_example_build.name
}

output "codepipeline_name" {
  value = aws_codepipeline.overlay_example_pipeline.name
}

output "codepipeline_bucket" {
  value = aws_s3_bucket.codepipeline_bucket.bucket
}