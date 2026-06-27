module "networking" {
  source = "../../modules/networking"

  project_name = var.project_name
  environment  = var.environment

  app_vpc_cidr     = var.app_vpc_cidr
  backend_vpc_cidr = var.backend_vpc_cidr
  db_vpc_cidr      = var.db_vpc_cidr
}

module "peering" {
  source      = "../../modules/peering"
  environment = var.environment

  app_vpc_id     = module.networking.app_vpc_id
  backend_vpc_id = module.networking.backend_vpc_id
  db_vpc_id      = module.networking.db_vpc_id

  app_vpc_cidr     = var.app_vpc_cidr
  backend_vpc_cidr = var.backend_vpc_cidr
  db_vpc_cidr      = var.db_vpc_cidr

  app_route_table_id             = module.networking.app_public_route_table_id
  backend_private_route_table_id = module.networking.backend_private_route_table_id
  db_route_table_id              = module.networking.db_private_route_table_id
}

module "security" {
  source = "../../modules/security"

  environment = var.environment

  admin_ip = var.admin_ip

  app_vpc_id     = module.networking.app_vpc_id
  backend_vpc_id = module.networking.backend_vpc_id
  db_vpc_id      = module.networking.db_vpc_id

  app_vpc_cidr     = var.app_vpc_cidr
  backend_vpc_cidr = var.backend_vpc_cidr
}

module "ec2" {
  source = "../../modules/ec2"

  environment   = var.environment
  ami_id        = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  # Subnet IDs
  app_public_subnet_az1_id = module.networking.app_public_subnet_az1_id
  app_public_subnet_az2_id = module.networking.app_public_subnet_az2_id

  backend_public_subnet_id  = module.networking.backend_public_subnet_id
  backend_private_subnet_id = module.networking.backend_private_subnet_id

  # Security group IDs
  frontend_sg_id = module.security.frontend_sg_id
  bastion_sg_id  = module.security.bastion_sg_id
  backend_sg_id  = module.security.backend_sg_id

  # Database details (RDS)
  rds_endpoint = module.rds.rds_endpoint

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}

module "alb" {
  source = "../../modules/alb"

  environment = var.environment

  app_vpc_id = module.networking.app_vpc_id

  alb_sg_id = module.security.alb_sg_id

  app_public_subnet_az1_id = module.networking.app_public_subnet_az1_id
  app_public_subnet_az2_id = module.networking.app_public_subnet_az2_id

  frontend_1_id = module.ec2.frontend_1_id
  frontend_2_id = module.ec2.frontend_2_id
}

module "rds" {
  source = "../../modules/rds"

  environment = var.environment

  db_private_subnet_az1_id = module.networking.db_private_subnet_az1_id
  db_private_subnet_az2_id = module.networking.db_private_subnet_az2_id

  rds_sg_id = module.security.rds_sg_id

  db_name           = var.db_name
  db_username       = var.db_username
  db_password       = var.db_password
  db_instance_class = var.db_instance_class
  multi_az          = var.multi_az
}