resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs-cluster/${var.cluster_name}"
  retention_in_days = 7
}
