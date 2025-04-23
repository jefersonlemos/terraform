#SUBNETS
#It creates subnets dynamically and associates them with the route tables
resource "aws_subnet" "main" {
  for_each                = var.routes
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  map_public_ip_on_launch = each.value.subnet_type == "public" ? true : false
  tags = {
    Name        = "${local.full_name}-subnet-${each.value.subnet_type}"
    Subnet_type = each.value.subnet_type
  }

}

resource "aws_route_table_association" "this" {
  for_each       = var.routes
  subnet_id      = aws_subnet.main[each.value.cidr_block].id
  route_table_id = each.value.subnet_type == "private" ? one(data.aws_route_tables.route-private.ids) : one(data.aws_route_tables.route-public.ids)
}
