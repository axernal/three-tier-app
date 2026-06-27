output "rds_endpoint" {
  value = aws_db_instance.mysql.address
}
output "rds_identifier" {
  value = aws_db_instance.mysql.identifier
}