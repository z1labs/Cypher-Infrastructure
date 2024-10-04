output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.private[*].id
}

output "id_vpc" {
  value = aws_vpc.main.id
}
