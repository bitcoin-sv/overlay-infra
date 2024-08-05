variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "sg_name" {
  description = "Name for the Security Group"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}
