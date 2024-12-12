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

  tags = {
    Name = "${var.name}-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
}

resource "aws_main_route_table_association" "main" {
  count          = length(var.cidr)
  vpc_id         = var.vpc_id
  route_table_id = aws_route_table.main.*.id[count.index]
}