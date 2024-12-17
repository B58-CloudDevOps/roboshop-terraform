module "vpc" {
  for_each = var.vpc

  source = "./modules/vpc"

  cidr               = each.value["cidr"]
  subnets            = each.value["subnets"]
  env                = var.env
  availability_zones = each.value["availability_zones"]
  name               = each.key
  peering_vpcs       = each.value["peering_vpcs"]
  def_vpc_cidr       = var.def_vpc_cidr
}

module "db" {
  for_each = var.db_servers

  source         = "./modules/ec2"
  component_name = each.key
  env            = var.env
  ports          = each.value["ports"]
  instance_type  = each.value["instance_type"]

  vpc_id = module.vpc["main"].subnets["db"].subnets
}