variable "environment" {}

variable "ami_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "app_public_subnet_az1_id" {}

variable "app_public_subnet_az2_id" {}

variable "backend_public_subnet_id" {}

variable "backend_private_subnet_id" {}

variable "frontend_sg_id" {}

variable "bastion_sg_id" {}

variable "backend_sg_id" {}


variable "rds_endpoint" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
}