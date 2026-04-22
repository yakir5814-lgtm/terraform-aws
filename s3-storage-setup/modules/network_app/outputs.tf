output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "instance_public_ip" {
  description = "The public IP address of the EC2 instance"
  value       = aws_instance.app_server.public_ip
}

output "subnet_ids" {
  description = "The IDs of the created subnets"
  value       = aws_subnet.this[*].id
}
