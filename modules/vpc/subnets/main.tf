resource "aws_subnet" "main" {
  count             = length(var.cidr)
  vpc_id            = var.vpc_id
  cidr_block        = var.cidr[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${each.key}-${var.env}"
  }
}
