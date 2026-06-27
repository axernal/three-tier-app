variable "project_name" {}
variable "environment" {}

variable "admin_ip" {}

variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}

variable "app_vpc_cidr" {}
variable "backend_vpc_cidr" {}
variable "db_vpc_cidr" {}

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}

variable "db_instance_class" {}
variable "multi_az" {}
variable "aws_region" {}