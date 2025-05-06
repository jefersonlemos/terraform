#SUBNETS
#It creates subnets dynamically and associates them with the route tables


#TODO - Check what happens if we set more routes than AZs, it should break
locals {
  routes_list = [for route in var.routes : route.cidr_block]
}
resource "aws_subnet" "main" {
  for_each                = var.routes
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = data.aws_availability_zones.available.names[index("${local.routes_list}","${each.value.cidr_block}")]
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
