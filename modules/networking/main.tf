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

#App Public Subnet AZ1
resource "aws_subnet" "app_public_az1" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.10.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-app-public-az1"
  }
}
#App Public Subnet AZ2
resource "aws_subnet" "app_public_az2" {
  vpc_id                  = aws_vpc.app_vpc.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = data.aws_availability_zones.available.names[1]

  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-app-public-az2"
  }
}
#Backend Public Subnet (Bastion)
resource "aws_subnet" "backend_public" {
  vpc_id                  = aws_vpc.backend_vpc.id
  cidr_block              = "10.20.1.0/24"
  availability_zone       = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environment}-backend-public"
  }
}

#Backend Private Subnet
resource "aws_subnet" "backend_private" {
  vpc_id            = aws_vpc.backend_vpc.id
  cidr_block        = "10.20.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-backend-private"
  }
}

#DB Private Subnet AZ1
resource "aws_subnet" "db_private_az1" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.30.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.environment}-db-private-az1"
  }
}

#DB Private Subnet AZ2
resource "aws_subnet" "db_private_az2" {
  vpc_id            = aws_vpc.db_vpc.id
  cidr_block        = "10.30.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.environment}-db-private-az2"
  }
}

#App VPC Internet Gateway
resource "aws_internet_gateway" "app_igw" {
  vpc_id = aws_vpc.app_vpc.id

  tags = {
    Name = "${var.environment}-app-igw"
  }
}

#Backend VPC Internet Gateway
resource "aws_internet_gateway" "backend_igw" {
  vpc_id = aws_vpc.backend_vpc.id

  tags = {
    Name = "${var.environment}-backend-igw"
  }
}
#App Public Route Table
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

#Backend Public Route Table
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

#Backend Private Route Table
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

#DB private Route Table
resource "aws_route_table" "db_private_rt" {
  vpc_id = aws_vpc.db_vpc.id

  tags = {
    Name = "${var.environment}-db-private-rt"
  }
}

#Route Table Associations AZ1
resource "aws_route_table_association" "app_public_az1_assoc" {
  subnet_id      = aws_subnet.app_public_az1.id
  route_table_id = aws_route_table.app_public_rt.id
}

#Route Table Associations AZ2
resource "aws_route_table_association" "app_public_az2_assoc" {
  subnet_id      = aws_subnet.app_public_az2.id
  route_table_id = aws_route_table.app_public_rt.id
}

#backend public
resource "aws_route_table_association" "backend_public_assoc" {
  subnet_id      = aws_subnet.backend_public.id
  route_table_id = aws_route_table.backend_public_rt.id
}
#backend private
resource "aws_route_table_association" "backend_private_assoc" {
  subnet_id      = aws_subnet.backend_private.id
  route_table_id = aws_route_table.backend_private_rt.id
}

#DB Az1
resource "aws_route_table_association" "db_private_az1_assoc" {
  subnet_id      = aws_subnet.db_private_az1.id
  route_table_id = aws_route_table.db_private_rt.id
}

#DB Az2
resource "aws_route_table_association" "db_private_az2_assoc" {
  subnet_id      = aws_subnet.db_private_az2.id
  route_table_id = aws_route_table.db_private_rt.id
}

#elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.environment}-nat-eip"
  }
}
#NAT Gateway
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