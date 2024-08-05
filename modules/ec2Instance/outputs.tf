output "bastion_eip" {
  value = aws_eip.bastion_eip.public_ip
}

output "launch_configuration_name" {
  value = aws_launch_configuration.ecs.name
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.ecs.name
}
