output "app_backend_peering_id" {
  value = aws_vpc_peering_connection.app_backend.id
}

output "backend_db_peering_id" {
  value = aws_vpc_peering_connection.backend_db.id
}