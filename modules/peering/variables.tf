variable "app_vpc_id" {
  type = string
}

variable "backend_vpc_id" {
  type = string
}

variable "db_vpc_id" {
  type = string
}

variable "app_vpc_cidr" {
  type = string
}

variable "backend_vpc_cidr" {
  type = string
}

variable "db_vpc_cidr" {
  type = string
}

variable "app_route_table_id" {
  type = string
}


variable "backend_private_route_table_id" {
  type = string
}

variable "db_route_table_id" {
  type = string
}

variable "environment" {
  type = string
}