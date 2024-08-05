variable "cluster_identifier" {
  description = "The identifier for the RDS cluster"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instances"
  type        = string
}

variable "instance_count" {
  description = "The number of RDS instances to create"
  type        = number
}

variable "master_username" {
  description = "The master username for the RDS cluster"
  type        = string
}

variable "master_password" {
  description = "The master password for the RDS cluster"
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the initial database"
  type        = string
}

variable "backup_retention_period" {
  description = "The number of days to retain backups"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "The preferred backup window"
  type        = string
  default     = "07:00-09:00"
}

variable "subnet_ids" {
  description = "The list of subnet IDs for the DB subnet group"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "The name of the DB subnet group"
  type        = string
}

variable "security_group_id" {
  description = "The ID of the security group for the RDS instances"
  type        = string
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default     = "8.0.mysql_aurora.3.07.1"
}

variable "final_snapshot_identifier" {
  description = "Identifier for the final snapshot"
  type        = string
  default     = "final-snapshot-2"
}
