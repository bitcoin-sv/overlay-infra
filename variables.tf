variable "projectName" {
  description = "Project name for resources naming convention"
  type        = string
  default     = "overlay"
}

variable "appName" {
  description = "Project name for resources naming convention"
  type        = string
  default     = "overlay-example"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

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

variable "instance_type" {
  description = "EC2 instance type for ECS instances"
  default     = "t3a.micro"
}

variable "s3_bucket" {
  description = "S3 bucket for AWS logs configuration"
  type        = string
  default     = "overlay-bucket"
}

variable "asg_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  default     = 1
}

variable "asg_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  default     = 2
}

variable "asg_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  default     = 3
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate"
  type        = string
}

variable "rds_master_username" {
  description = "Master username for the RDS cluster"
  type        = string
}

variable "rds_master_password" {
  description = "Master password for the RDS cluster"
  type        = string
  sensitive   = true
}

variable "rds_database_name" {
  description = "Initial database name for the RDS cluster"
  type        = string
}

variable "rds_instance_class" {
  description = "Instance class for the RDS instances"
  type        = string
  default     = "db.t3.medium"
}

variable "github_connection_arn" {
  description = "The ARN of the CodeStar GitHub connection"
  type        = string
}

variable "ecr_repo_name" {
  type = string
}

variable "image_tag" {
  type = string
}