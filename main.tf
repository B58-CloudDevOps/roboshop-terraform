module "vpc" {
  for_each = var.vpc

  source = "./modules/vpc"

  cidr              = each.value["cidr"]
  subnets           = each.value["subnets"]
  env               = var.env
  availabilty_zones = each.value["availabilty_zones"]
}