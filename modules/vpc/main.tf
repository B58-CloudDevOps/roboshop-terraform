resource "aws_vpc" "main" {

  cidr_block = var.cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

module "subnets" {
  source             = "./subnets"
  for_each           = var.subnets
  name               = each.key
  availability_zones = var.availability_zones
  vpc_id             = aws_vpc.main.id
  cidr               = each.value["cidr"]
  env                = var.env
}




# Provisions NAT Gateway 
resource "aws_eip" "ngw" {
  count  = length(var.availability_zones)
  domain = "vpc"
}

resource "aws_nat_gateway" "ngw" {
  count = length(var.availability_zones)

  allocation_id = aws_eip.ngw.*.id[count.index]
  subnet_id     = module.subnets["public"].subnets[count.index]

  tags = {
    Name = "ngw-${var.env}-${split("-", var.availability_zones[count.index])[2]}"
  }
  depends_on = [aws_internet_gateway.igw]
}

# # Private Subnet Egress to Internet

# Public Route 
# resource "aws_route" "igw_route" {
#   count                  = var.name == "public" ? length(var.cidr) : 0
#   route_table_id         = aws_route_table.main.*.id[count.index]
#   destination_cidr_block = "0.0.0.0/0"
#   gateway_id             = aws_internet_gateway.igw.*.id[0]
# }
