variable "service_name" {
  description = "Name for the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}

variable "task_definition_arn" {
  description = "ARN of the task definition"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
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

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_port" {
  description = "Port of the container"
  type        = number
}