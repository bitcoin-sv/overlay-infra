variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "docker_image_version" {
  description = "Docker image version"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 8080
}

variable "task_virtual_cpus" {
  description = "Number of virtual CPUs for the task"
  type        = number
}

variable "task_memory_max" {
  description = "Maximum amount of memory for the task"
  type        = number
}

variable "db_host" {
  description = "Database host"
  type        = string
}

variable "db_port" {
  description = "Database port"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnets for the service"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for the service"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the load balancer target group"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "has_https" {
  description = "Whether the service uses HTTPS"
  type        = string
  default     = "false"
}

variable "listener_arn" {
  description = "ARN of the load balancer listener"
  type        = string
}

variable "environment_cname" {
  description = "CNAME for the environment"
  type        = string
}

variable "app_site_tg_priority" {
  description = "Priority of the target group for the app site"
  type        = number
}

variable "alb_health_check_interval" {
  description = "Interval for the ALB health check"
  type        = number
}

variable "alb_health_check_path" {
  description = "Path for the ALB health check"
  type        = string
}

variable "alb_health_check_timeout" {
  description = "Timeout for the ALB health check"
  type        = number
}

variable "alb_health_check_healthy_threshold" {
  description = "Healthy threshold for the ALB health check"
  type        = number
}

variable "alb_health_check_unhealthy_threshold" {
  description = "Unhealthy threshold for the ALB health check"
  type        = number
}

variable "alb_health_check_start_period" {
  description = "Start period for the ALB health check"
  type        = number
}

variable "container_network_mode" {
  description = "Network mode for the container"
  type        = string
}

variable "ecs_tasks_number" {
  description = "Number of ECS tasks"
  type        = number
}

variable "certificate_arn" {
  description = "ARN of the SSL certificate"
  type        = string
}

variable "vpc_id" {
  type        = string
}
