output "web_sg_id" {
  description = "The ID of the Web Security Group"
  value       = aws_security_group.web_sg.id
}

output "app_sg_id" {
  description = "The ID of the Application Security Group"
  value       = aws_security_group.app_sg.id
}