output "ec2_instance_ids" {
  description = "The IDs of the EC2 instances"
  value       = [for instance in aws_instance.ec2_instance : instance.id]
}

output "ec2_public_ips" {
  description = "The public IPs of the EC2 instances"
  value       = [for instance in aws_instance.ec2_instance : instance.public_ip]
}

output "security_group_id" {
  description = "The ID of the security group"
  value       = aws_security_group.ec2_sg.id
}
