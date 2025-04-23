#TODO - VPC Module

#1. #DONE Creates the VPC
#2.  Creates the subnets
#3. Creates the Nat Gateway
#4. Creates the routes
############################################################


#VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
}

#IGW
resource "aws_internet_gateway" "internet" {
  vpc_id = aws_vpc.main.id
}



#NAT GATEWAY
#IF enabled, but for poc we're going to use the default route table and public subnets
