resource "aws_subnet" "main" {
  count             = length(var.cidr)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table" "main" {
  count = length(var.cidr)

  vpc_id = var.vpc_id

  # route {
  #   cidr_block                = "172.31.0.0/16" # Tools VPC Route, needs improvement
  #   vpc_peering_connection_id = var.vpc_peering_ids
  # }

  tags = {
    Name = "${var.name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table_association" "main" {
  count          = length(var.cidr)
  subnet_id      = aws_subnet.main.*.id[count.index]
  route_table_id = aws_route_table.main.*.id[count.index]
}

resource "aws_internet_gateway" "igw" {
  count = var.name == "public" ? 1 : 0

  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-igw"
  }
}

resource "aws_route" "igw_route" {
  count                  = var.name == "public" ? length(var.cidr) : 0
  route_table_id         = aws_route_table.main.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.*.id[0]
}
resource "aws_route" "ngw_route" {
  count                  = var.name != "public" ? length(var.cidr) : 0
  route_table_id         = aws_route_table.main.*.id[count.index]
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.ngw_ids[count.index]
}

# resource "aws_route" "all_route" {
#   count                     = length(var.cidr)
#   route_table_id            = aws_route_table.main.*.id[count.index]
#   destination_cidr_block    = "172.31.0.0/16" # Default VPC Cidr 
#   vpc_peering_connection_id = var.vpc_peering_ids
# }