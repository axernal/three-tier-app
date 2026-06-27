output "app_vpc_id" {
  value = aws_vpc.app_vpc.id
}

output "backend_vpc_id" {
  value = aws_vpc.backend_vpc.id
}

output "db_vpc_id" {
  value = aws_vpc.db_vpc.id
}

output "app_public_subnet_az1_id" {
  value = aws_subnet.app_public_az1.id
}

output "app_public_subnet_az2_id" {
  value = aws_subnet.app_public_az2.id
}

output "backend_public_subnet_id" {
  value = aws_subnet.backend_public.id
}

output "backend_private_subnet_id" {
  value = aws_subnet.backend_private.id
}

output "db_private_subnet_az1_id" {
  value = aws_subnet.db_private_az1.id
}

output "db_private_subnet_az2_id" {
  value = aws_subnet.db_private_az2.id
}

output "app_public_route_table_id" {
  value = aws_route_table.app_public_rt.id
}

output "backend_private_route_table_id" {
  value = aws_route_table.backend_private_rt.id
}

output "db_private_route_table_id" {
  value = aws_route_table.db_private_rt.id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat_gateway.id
}