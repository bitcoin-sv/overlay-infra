variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "overlay-example"
}

variable "github_connection_arn" {
  description = "The ARN of the CodeStar GitHub connection"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "DB_PORT" {
  type        = string
}

variable "DB_USER" {
  type        = string
}

variable "DB_PASSWORD" {
  type        = string
}

variable "DB_NAME" {
  type        = string
}

variable "DB_ENDPOINT" {
  type        = string
}

variable "S3_BUCKET" {
  type        = string
}