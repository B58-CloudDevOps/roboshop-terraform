module "vpc" {
  for_each = var.vpc

  source = "./modules/vpc"

  cidr               = each.value["cidr"]
  subnets            = each.value["subnets"]
  env                = var.env
  availability_zones = each.value["availability_zones"]
}