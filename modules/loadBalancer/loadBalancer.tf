resource "aws_lb" "main" {
  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = var.lb_type
  security_groups    = [var.security_group_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = var.enable_deletion_protection
}

resource "aws_lb_target_group" "main" {
  name     = var.tg_name
  port     = var.tg_port
  protocol = var.tg_protocol
  vpc_id   = var.vpc_id

  health_check {
    interval            = var.health_check_interval
    path                = var.health_check_path
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_http_port
  protocol          = var.listener_http_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  # default_action {
  #   type             = "forward"
  #   target_group_arn = aws_lb_target_group.main.arn
  # }
}

# Uncomment and use for HTTPS listener
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = var.listener_https_port
  protocol          = var.listener_https_protocol
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
