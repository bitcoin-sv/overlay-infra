output "ecs_service_name" {
  value = aws_ecs_service.overlay_example_service.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.overlay_example_task.arn
}

output "target_group_arn" {
  value = aws_lb_target_group.overlay_example_tg.arn
}

output "docker_image_version" {
  value = var.docker_image_version
}