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
  ngw_ids            = aws_nat_gateway.ngw.*.id
  vpc_peering_ids    = aws_vpc_peering_connection.main["tools"].id
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
}

# Peerting to default vpc 
resource "aws_vpc_peering_connection" "main" {
  for_each = var.peering_vpcs

  peer_vpc_id = each.value["id"]
  vpc_id      = aws_vpc.main.id
  auto_accept = true

  tags = {
    Name = "${each.key}-peer"
  }
}

resource "aws_route" "on_peer_side" {
  for_each                  = var.peering_vpcs
  route_table_id            = each.value["route_table_id"]
  destination_cidr_block    = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main[each.key].id
}

output "def_vpc_cidr" {
  value = var.def_vpc_cidr
}