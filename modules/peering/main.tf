resource "aws_vpc_peering_connection" "app_backend" {
  vpc_id      = var.app_vpc_id
  peer_vpc_id = var.backend_vpc_id
  auto_accept = true

  tags = {
    Name = "${var.environment}-app-backend-peering"
  }
}

resource "aws_vpc_peering_connection" "backend_db" {
  vpc_id      = var.backend_vpc_id
  peer_vpc_id = var.db_vpc_id
  auto_accept = true

  tags = {
    Name = "${var.environment}-backend-db-peering"
  }
}

# App -> Backend
resource "aws_route" "app_to_backend" {
  route_table_id            = var.app_route_table_id
  destination_cidr_block    = var.backend_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_backend.id
}

# Backend -> App
resource "aws_route" "backend_to_app" {
  route_table_id            = var.backend_private_route_table_id
  destination_cidr_block    = var.app_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.app_backend.id
}

# Backend -> DB
resource "aws_route" "backend_to_db" {
  route_table_id            = var.backend_private_route_table_id
  destination_cidr_block    = var.db_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.backend_db.id
}

# DB -> Backend
resource "aws_route" "db_to_backend" {
  route_table_id            = var.db_route_table_id
  destination_cidr_block    = var.backend_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.backend_db.id
}