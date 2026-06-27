output "frontend_1_id" {
  value = aws_instance.frontend_1.id
}

output "frontend_2_id" {
  value = aws_instance.frontend_2.id
}

output "backend_id" {
  value = aws_instance.backend.id
}

output "bastion_id" {
  value = aws_instance.bastion.id
}

output "frontend_1_private_ip" {
  value = aws_instance.frontend_1.private_ip
}

output "frontend_2_private_ip" {
  value = aws_instance.frontend_2.private_ip
}

output "backend_private_ip" {
  value = aws_instance.backend.private_ip
}