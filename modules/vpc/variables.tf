variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "vpc_name" {
  description = "Name for the VPC"
  type        = string
}

variable "igw_name" {
  description = "Name for the Internet Gateway"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR blocks"
  type        = list(string)
}

variable "public_subnet_name" {
  description = "Name prefix for public subnets"
  type        = string
}

variable "private_subnet_name" {
  description = "Name prefix for private subnets"
  type        = string
}

variable "public_route_table_name" {
  description = "Name for the public route table"
  type        = string
}

variable "private_route_table_name" {
  description = "Name for the private route table"
  type        = string
}

variable "nat_gw_name" {
  description = "Name for the NAT Gateway"
  type        = string
}