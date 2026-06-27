variable "project_name" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "admin_ip" {
  type        = string
  description = "Administrator public IP with CIDR notation"
}

variable "ami_id" {
  type        = string
  description = "AMI ID used for EC2 instances"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "key_name" {
  type        = string
  description = "AWS key pair name"
}

variable "app_vpc_cidr" {
  type        = string
  description = "CIDR block for application VPC"
}

variable "backend_vpc_cidr" {
  type        = string
  description = "CIDR block for backend VPC"
}

variable "db_vpc_cidr" {
  type        = string
  description = "CIDR block for database VPC"
}

variable "db_name" {
  type        = string
  description = "Database name"
}

variable "db_username" {
  type        = string
  description = "Database username"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "Database password"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
}

variable "multi_az" {
  type        = bool
  description = "Enable Multi-AZ deployment"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}