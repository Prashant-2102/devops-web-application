output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.web_server.id
}

output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.web_server.public_dns
}

output "default_vpc_id" {
  description = "Default VPC ID"
  value       = data.aws_vpc.default.id
}

output "default_security_group_id" {
  description = "Default Security Group ID"
  value       = data.aws_security_group.default.id
}