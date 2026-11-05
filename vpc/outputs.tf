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

output "internet_gateway_id" {
  description = "The ID of the internet gateway, or null when the VPC has no public subnets"
  value       = one(aws_internet_gateway.igw[*].id)
}

output "nat_gateway_public_ips" {
  description = "The public IP addresses of the NAT gateways. Outbound traffic from the private subnets uses these addresses, so partners add them to their allow-lists"
  value       = aws_eip.nat[*].public_ip
}

output "nat_gateway_ids" {
  description = "The IDs of the NAT gateways, used for CloudWatch alarms on NAT gateway metrics"
  value       = aws_nat_gateway.main[*].id
}

output "public_route_table_id" {
  description = "The ID of the public route table, or null when the VPC has no public subnets. Used to attach VPC gateway endpoints"
  value       = one(aws_route_table.public[*].id)
}

output "private_app_route_table_ids" {
  description = "The IDs of the private application route tables, in the same order as the availability zones. Used to attach VPC gateway endpoints"
  value       = aws_route_table.private_app[*].id
}
