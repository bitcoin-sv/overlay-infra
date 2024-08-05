output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "ec2_instance_profile_name" {
  value = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ecs_role_arn" {
  value = aws_iam_role.ecs_role.arn
}
