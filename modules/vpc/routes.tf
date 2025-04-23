
#ROUTE TABLES
#Creates two routes, one for private and one for public
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.internet.id
  }


  tags = {
    Name        = "${local.full_name}-route-table-public"
    Subnet_type = "public"
  }


}
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    #Change it to a NAT gateway when needed, but for now let's treat it as a fake private subnet
    gateway_id = aws_internet_gateway.internet.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.internet.id
  }


  tags = {
    Name        = "${local.full_name}-route-table-private"
    Subnet_type = "private"
  }


}
