resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.cluster_name}-scale-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = var.autoscaling_group_name
}

resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.cluster_name}-scale-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = var.autoscaling_group_name
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_up" {
  alarm_name          = "${var.cluster_name}-cluster-scale-up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Maximum"
  threshold           = 75
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_down" {
  alarm_name          = "${var.cluster_name}-cluster-scale-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 5
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 50
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]

  dimensions = {
    ClusterName = var.cluster_name
  }
}
