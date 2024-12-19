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
  depends_on = [module.vpc]

  source   = "./modules/ec2"
  for_each = var.db_servers

  component_name = each.key

  env           = var.env
  vault_token   = var.vault_token
  ports         = each.value["ports"]
  instance_type = each.value["instance_type"]

  hosted_zone_id = var.hosted_zone_id
  bastion_host   = var.bastion_host
  subnet_ids     = module.vpc["main"].subnets["db"].subnets
  vpc_id         = module.vpc["main"].vpc_id
}

module "app" {
  depends_on = [module.db]

  source   = "./modules/ec2"
  for_each = var.app_servers

  component_name = each.key

  env         = var.env
  vault_token = var.vault_token

  instance_type = each.value["instance_type"]
  ports         = each.value["ports"]

  vpc_id         = module.vpc["main"].vpc_id
  hosted_zone_id = var.hosted_zone_id
  bastion_host   = var.bastion_host
  subnet_ids     = module.vpc["main"].subnets["app"].subnets
}


module "web" {
  source     = "./modules/ec2"
  depends_on = [module.app]

  for_each = var.web_servers

  component_name = each.key
  env            = var.env
  vault_token    = var.vault_token
  ports          = each.value["ports"]
  instance_type  = each.value["instance_type"]
  vpc_id         = module.vpc["main"].vpc_id
  hosted_zone_id = var.hosted_zone_id
  bastion_host   = var.bastion_host
  subnet_ids     = module.vpc["main"].subnets["web"].subnets
}

module "load-balancers" {
  for_each           = var.load_balancers
  depends_on         = [module.web]
  source             = "./modules/load-balancers"
  component_name     = each.key
  load_balancer_type = each.value["load_balancer_type"]
  internal           = each.value["internal"]
  env                = var.env
  vpc_id             = module.vpc["main"].vpc_id
  subnet_ids         = module.vpc["main"].subnets["public"].subnets
  instance_id        = module.web["frontend"].instance_id
}