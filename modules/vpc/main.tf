resource "aws_vpc" "main" {

  cidr_block = var.cidr

  tags = {
    Name = "${var.env}-vpc"
  }

}

module "subnets" {
  source   = "./subnets"
  for_each = var.subnets

  name = each.key
  cidr = each.value["cidr"]
}