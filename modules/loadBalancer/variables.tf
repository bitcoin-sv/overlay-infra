variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "tg_name" {
  description = "Name of the target group"
  type        = string
}

variable "load_balancer_sg_id" {
  description = "ID of the load balancer security group"
  type        = string
}

variable "internal_access_sg_id" {
  description = "ID of the internal access security group"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "lb_name" {
  description = "Name of the load balancer"
  type        = string
  default     = "ecs-lb"
}

variable "lb_internal" {
  description = "Whether the load balancer is internal or external"
  type        = bool
  default     = false
}

variable "lb_type" {
  description = "Type of the load balancer"
  type        = string
  default     = "application"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for the load balancer"
  type        = bool
  default     = false
}

variable "tg_port" {
  description = "Port for the target group"
  type        = number
  default     = 80
}

variable "tg_protocol" {
  description = "Protocol for the target group"
  type        = string
  default     = "HTTP"
}

variable "health_check_interval" {
  description = "Interval for the health check"
  type        = number
  default     = 30
}

variable "health_check_path" {
  description = "Path for the health check"
  type        = string
  default     = "/"
}

variable "health_check_timeout" {
  description = "Timeout for the health check"
  type        = number
  default     = 5
}

variable "health_check_healthy_threshold" {
  description = "Healthy threshold for the health check"
  type        = number
  default     = 5
}

variable "health_check_unhealthy_threshold" {
  description = "Unhealthy threshold for the health check"
  type        = number
  default     = 2
}

variable "health_check_matcher" {
  description = "Matcher for the health check"
  type        = string
  default     = "200"
}

variable "listener_http_port" {
  description = "Port for the HTTP listener"
  type        = number
  default     = 80
}

variable "listener_http_protocol" {
  description = "Protocol for the HTTP listener"
  type        = string
  default     = "HTTP"
}

# Uncomment and use for HTTPS listener
variable "listener_https_port" {
  description = "Port for the HTTPS listener"
  type        = number
  default     = 443
}

variable "listener_https_protocol" {
  description = "Protocol for the HTTPS listener"
  type        = string
  default     = "HTTPS"
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}
