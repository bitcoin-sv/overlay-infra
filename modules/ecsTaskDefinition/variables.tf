variable "family" {
  description = "Family name for the task definition"
  type        = string
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
}

variable "memory" {
  description = "Memory for the task"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Image for the container"
  type        = string
}

variable "container_port" {
  description = "Port for the container"
  type        = number
}
