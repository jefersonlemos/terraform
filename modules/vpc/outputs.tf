#VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
  
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = aws_vpc.main.arn
  
}

#SUBNETS
output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [
    for subnet in aws_subnet.main :
    subnet.id if subnet.tags["Subnet_type"] == "private"
  ]
}

output "public_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [
    for subnet in aws_subnet.main :
    subnet.id if subnet.tags["Subnet_type"] == "public"
  ]
}

#SG
output "default_security_group_id" {
  description = "The ID of the default security group for the VPC"
  value       = aws_vpc.main.default_security_group_id
}