variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_image" {
  description = "AMI ID for the ECS instances"
  type        = string
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
}

variable "ecs_instance_type" {
  description = "EC2 instance type for ECS instances"
  type        = string
}

variable "public_subnet_ids" {
  description = "ID of the public subnet"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "internal_access_sg" {
  description = "ID of the internal access security group"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket for AWS logs configuration"
  type        = string
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
}

variable "ec2_instance_profile_name" {
  description = "InstanceProfile name"
  type        = string
}

variable "network_interface_private_ip" {
  description = "InstanceProfile name"
  type        = list(string)
}

variable "bastion_sg_id" {
  description = "ID of the bastion security group"
  type        = string
}

variable "root_volume_size" {
  description = "Size of the root EBS volume"
  type        = number
  default     = 100
}

variable "ebs_volume_size" {
  description = "Size of the additional EBS volume"
  type        = number
  default     = 100
}