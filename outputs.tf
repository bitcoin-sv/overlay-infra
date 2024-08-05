output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "ecs_cluster_id" {
  value = module.ecs_cluster.cluster_id
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}

output "lb_dns_name" {
  value = module.load_balancer.lb_dns_name
}

output "ec2_role_arn" {
  value = module.iam_roles.ec2_role_arn
}

output "ec2_instance_profile_name" {
  value = module.iam_roles.ec2_instance_profile_name
}

output "ecs_role_arn" {
  value = module.iam_roles.ecs_role_arn
}

output "log_group_name" {
  value = module.log_group.log_group_name
}

output "bastion_sg_id" {
  value = module.security_groups.bastion_sg_id
}

output "ecs_cluster_arn" {
  value = module.ecs_cluster.cluster_arn
}

output "bastion_eip" {
  value = module.ec2_instances.bastion_eip
}

output "launch_configuration_name" {
  value = module.ec2_instances.launch_configuration_name
}

output "autoscaling_group_name" {
  value = module.ec2_instances.autoscaling_group_name
}

output "scale_up_policy_arn" {
  value = module.cloudwatch.scale_up_policy_arn
}

output "scale_down_policy_arn" {
  value = module.cloudwatch.scale_down_policy_arn
}
