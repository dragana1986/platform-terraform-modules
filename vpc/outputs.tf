output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets, in the same order as the availability zones"
  value       = aws_subnet.public[*].id
}

output "public_subnet_cidrs" {
  description = "The CIDR blocks of the public subnets, in the same order as the availability zones"
  value       = aws_subnet.public[*].cidr_block
}

output "private_app_subnet_ids" {
  description = "The IDs of the private application subnets, in the same order as the availability zones"
  value       = aws_subnet.private_app[*].id
}

output "private_app_subnet_cidrs" {
  description = "The CIDR blocks of the private application subnets, in the same order as the availability zones"
  value       = aws_subnet.private_app[*].cidr_block
}
