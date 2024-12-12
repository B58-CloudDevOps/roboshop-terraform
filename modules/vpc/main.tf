resource "aws_vpc" "main" {

  cidr_block = var.cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

module "subnets" {
  source   = "./subnets"
  for_each = var.subnets

  availability_zones = var.availabilty_zones
  vpc_id             = aws_vpc.main.id
  cidr               = each.value["cidr"]
  env                = var.env
}