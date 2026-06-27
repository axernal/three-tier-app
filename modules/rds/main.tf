# DB subnet group

resource "aws_db_subnet_group" "db_subnet_group" {
  name = "${var.environment}-db-subnet-group"

  subnet_ids = [
    var.db_private_subnet_az1_id,
    var.db_private_subnet_az2_id
  ]

  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# MySQL RDS instance

resource "aws_db_instance" "mysql" {
  identifier = "${var.environment}-mysql-rds"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100

  storage_type      = "gp3"
  storage_encrypted = true

  username = var.db_username
  password = var.db_password

  db_name = var.db_name

  publicly_accessible = false

  multi_az = var.multi_az

  skip_final_snapshot = true

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids = [
    var.rds_sg_id
  ]

  backup_retention_period = 1

  tags = {
    Name = "${var.environment}-mysql-rds"
  }
}