resource "aws_ecs_task_definition" "main" {
  family                   = var.family
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.cpu
  memory                   = var.memory

  container_definitions = jsonencode([
    {
      name  = var.container_name
      image = var.container_image
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
    }
  ])
}
