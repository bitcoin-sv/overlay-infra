resource "aws_lb_target_group" "overlay_example_tg" {
  name     = "${var.project_name}-tg"
  port     = var.container_port
  protocol = var.has_https == "true" ? "HTTPS" : "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = var.alb_health_check_interval
    path                = var.alb_health_check_path
    timeout             = var.alb_health_check_timeout
    healthy_threshold   = var.alb_health_check_healthy_threshold
    unhealthy_threshold = var.alb_health_check_unhealthy_threshold
    matcher             = "200-399"
  }

  tags = {
    Name = "${var.cluster_name}-${var.project_name}-tg"
  }
}

resource "aws_lb_listener_rule" "overlay_example_listener_rule" {
  listener_arn = var.listener_arn
  priority     = var.app_site_tg_priority

  condition {
    host_header {
        values = [var.environment_cname]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.overlay_example_tg.arn
  }
}

resource "aws_iam_role" "ecs_execution_role" {
  name = "${var.cluster_name}-${var.project_name}-ecs-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  inline_policy {
    name   = "ecs-task-execution-role-policy"
    policy = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Action = [
            "ecr:*",
            "logs:*",
            "ssm:GetParameters",
            "secretsmanager:GetSecretValue",
            "kms:Decrypt"
          ],
          Resource = "*"
        }
      ]
    })
  }
}

resource "aws_ecs_task_definition" "overlay_example_task" {
  family                   = "${var.project_name}-${var.cluster_name}"
  network_mode             = var.container_network_mode
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_virtual_cpus
  memory                   = var.task_memory_max
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "overlay_example"
      image = var.docker_image_version
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/${var.cluster_name}/${var.project_name}/overlay-app"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "/ecs-task-output"
        }
      },
      environment = [
        {
          name  = "DB_HOST"
          value = var.db_host
        },
        {
          name  = "DB_PORT"
          value = var.db_port
        },
        {
          name  = "DB_USER"
          value = var.db_user
        },
        {
          name  = "DB_PASSWORD"
          value = var.db_password
        },
        {
          name  = "DB_NAME"
          value = var.db_name
        },
        {
          name  = "ENVIRONMENT"
          value = "prod"
        }
      ],
      cpu = var.task_virtual_cpus
      memory = var.task_memory_max
      memoryReservation = var.task_memory_max
    }
  ])
}

resource "aws_ecs_service" "overlay_example_service" {
  name            = "${var.cluster_name}-${var.project_name}-service"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.overlay_example_task.arn
  desired_count   = var.ecs_tasks_number
  launch_type     = "EC2"

  deployment_controller {
    type = "ECS"
  }

  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200

  load_balancer {
    target_group_arn = aws_lb_target_group.overlay_example_tg.arn
    container_name   = "overlay_example"
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = var.alb_health_check_start_period

  tags = {
    Name = "${var.cluster_name}-${var.project_name}-service"
  }
}

resource "aws_cloudwatch_log_group" "overlay_example_log_group" {
  name              = "/${var.cluster_name}/${var.project_name}/overlay-app"
  retention_in_days = 7
}
