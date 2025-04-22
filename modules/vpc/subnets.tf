
#ROUTE TABLES
resource "aws_route_table" "project_routes" {
  vpc_id = aws_vpc.main.id
  
  dynamic "route" {
    for_each = var.routes
    content {
        cidr_block = route.value.cidr_block
        gateway_id  = #Internet gateway
        #TODO - Mas aqui preciso colocar isso, somente se for subnet publica
        # se for privada, precisa sair pelo NAT
    }
  }
  #It creates multiple routes into the same route table, now I want to create multiple route_tables and multiple
  #routes within

data "aws_route_tables" "route-private" {
  vpc_id = aws_vpc.main.id

  filter {
    name   = "tag:Subnet_type"
    values = ["private"]
  }
}

data "aws_route_tables" "route-public" {

  vpc_id = aws_vpc.main.id
  # count  = length(var.routes)

  filter {
    name   = "tag:Subnet_type"
    values = ["route.destination-cidr-block"]
  }
}


#SUBNETS
resource "aws_subnet" "main" {
  for_each   = var.routes
  vpc_id     = aws_vpc.main.id
  cidr_block = each.value.cidr_block
  tags       = {
    Name        = "${local.full_name}-${each.value.subnet_type}"
    Subnet_type = each.value.subnet_type
  }

}

resource "aws_route_table_association" "this" {
  for_each       = var.routes
  subnet_id      = aws_subnet.main[each.value.cidr_block].id
  route_table_id = each.value.subnet_type == "private" ? one(data.aws_route_tables.route-private.ids) : one(data.aws_route_tables.route-public.ids)
}