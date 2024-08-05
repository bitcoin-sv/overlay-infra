output "sg_id" {
  value = aws_security_group.ecs.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}

output "internal_access_sg_id" {
  value = aws_security_group.internal_access_sg.id
}

output "load_balancer_sg_id" {
  value = aws_security_group.load_balancer.id
}