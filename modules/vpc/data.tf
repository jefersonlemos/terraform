data "aws_region" "current" {}

data "aws_route_tables" "route-private" {
  vpc_id = aws_vpc.main.id

  filter {
    name   = "tag:Subnet_type"
    values = ["private"]
  }
  depends_on = [ aws_route_table.private_route_table ]
}

data "aws_route_tables" "route-public" {

  vpc_id = aws_vpc.main.id
  # count  = length(var.routes)

  filter {
    name   = "tag:Subnet_type"
    values = ["public"]
  }
  depends_on = [ aws_route_table.public_route_table ]
}
