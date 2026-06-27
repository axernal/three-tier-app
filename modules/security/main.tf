# ALB security group

resource "aws_security_group" "alb_sg" {
  name        = "${var.environment}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.app_vpc_id

  ingress {
    description = "HTTP From Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

# Frontend security group

resource "aws_security_group" "frontend_sg" {
  name        = "${var.environment}-frontend-sg"
  description = "Frontend Security Group"
  vpc_id      = var.app_vpc_id

  ingress {
    description     = "HTTP From ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  ingress {
    description = "SSH From Admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-frontend-sg"
  }
}

# Bastion security group

resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment}-bastion-sg"
  description = "Bastion Security Group"
  vpc_id      = var.backend_vpc_id

  ingress {
    description = "SSH From Admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-bastion-sg"
  }
}

# Backend security group

resource "aws_security_group" "backend_sg" {
  name        = "${var.environment}-backend-sg"
  description = "Backend Security Group"
  vpc_id      = var.backend_vpc_id

  ingress {
    description = "NodeJS API From Frontend VPC"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [var.app_vpc_cidr]
  }

  ingress {
    description = "SSH From Bastion"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.bastion_sg.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-backend-sg"
  }
}

# RDS security group

resource "aws_security_group" "rds_sg" {
  name        = "${var.environment}-rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.db_vpc_id

  ingress {
    description = "MySQL From Backend VPC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [var.backend_vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-rds-sg"
  }
}