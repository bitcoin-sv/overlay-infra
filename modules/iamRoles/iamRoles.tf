resource "aws_iam_role" "ec2_role" {
  name = "${var.region}-${var.cluster_name}_EC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.region}-${var.cluster_name}_EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_iam_role" "ecs_role" {
  name = "${var.region}-${var.cluster_name}_ECSRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"]
}
