resource "aws_vpc" "app_vpc" {
  cidr_block           = var.app_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-app-tier-vpc"
  }
}

resource "aws_vpc" "backend_vpc" {
  cidr_block           = var.backend_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-backend-tier-vpc"
  }
}

resource "aws_vpc" "db_vpc" {
  cidr_block           = var.db_vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.environment}-db-tier-vpc"
  }
}

data "aws_availability_zones" "available" {}

# App public subnet (AZ1)
resource "aws_subnet" "app_public_az1" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-app-public-az1"
  }
}
# App public subnet (AZ2)
resource "aws_subnet" "app_public_az2" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-app-public-az2"
  }
}
# Backend public subnet (bastion)
resource "aws_subnet" "backend_public" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-backend-public"
  }
}

# Backend private subnet
resource "aws_subnet" "backend_private" {
  vpc_id            = aws_vpc.backend_vpc.id
  cidr_block        = "10.20.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-backend-private"
  }
}

# DB private subnet (AZ1)
resource "aws_subnet" "db_private_az1" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.30.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-db-private-az1"
  }
}

# DB private subnet (AZ2)
resource "aws_subnet" "db_private_az2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.30.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.environment}-db-private-az2"
  }
}

# App VPC internet gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.environment}-app-igw"
  }
}

# Backend VPC internet gateway
resource "aws_internet_gateway" "backend_igw" {
  vpc_id = aws_vpc.backend_vpc.id

  tags = {
    Name = "${var.environment}-backend-igw"
  }
}
# App public route table
resource "aws_route_table" "app_public_rt" {
  vpc_id = aws_vpc.app_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app_igw.id
  }

  tags = {
    Name = "${var.environment}-app-public-rt"
  }
}

# Backend public route table
resource "aws_route_table" "backend_public_rt" {
  vpc_id = aws_vpc.backend_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.backend_igw.id
  }

  tags = {
    Name = "${var.environment}-backend-public-rt"
  }
}

# Backend private route table
resource "aws_route_table" "backend_private_rt" {
  vpc_id = aws_vpc.backend_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "${var.environment}-backend-private-rt"
  }
}

# DB private route table
resource "aws_route_table" "db_private_rt" {
  vpc_id = aws_vpc.db_vpc.id

  tags = {
    Name = "${var.environment}-db-private-rt"
  }
}

# Route table associations (AZ1)
resource "aws_route_table_association" "app_public_az1_assoc" {
  subnet_id      = aws_subnet.app_public_az1.id
  route_table_id = aws_route_table.app_public_rt.id
}

# Route table associations (AZ2)
resource "aws_route_table_association" "app_public_az2_assoc" {
  subnet_id      = aws_subnet.app_public_az2.id
  route_table_id = aws_route_table.app_public_rt.id
}

# Backend public route table association
resource "aws_route_table_association" "backend_public_assoc" {
  subnet_id      = aws_subnet.backend_public.id
  route_table_id = aws_route_table.backend_public_rt.id
}
# Backend private route table association
resource "aws_route_table_association" "backend_private_assoc" {
  subnet_id      = aws_subnet.backend_private.id
  route_table_id = aws_route_table.backend_private_rt.id
}

# DB route table association (AZ1)
resource "aws_route_table_association" "db_private_az1_assoc" {
  subnet_id      = aws_subnet.db_private_az1.id
  route_table_id = aws_route_table.db_private_rt.id
}

# DB route table association (AZ2)
resource "aws_route_table_association" "db_private_az2_assoc" {
  subnet_id      = aws_subnet.db_private_az2.id
  route_table_id = aws_route_table.db_private_rt.id
}

# Elastic IP for NAT gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}
# NAT gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.backend_public.id

  depends_on = [
    aws_internet_gateway.backend_igw
  ]

  tags = {
    Name = "${var.environment}-nat-gateway"
  }
}