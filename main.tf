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
  zone_id            = var.zone_id
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

  vpc_id       = module.vpc["main"].vpc_id
  zone_id      = var.zone_id
  bastion_host = var.bastion_host
  subnet_ids   = module.vpc["main"].subnets["db"].subnets
}

module "app" {
  depends_on = [module.db]

  source   = "./modules/ec2"
  for_each = var.app_servers

  component_name = each.key

  env           = var.env
  vault_token   = var.vault_token
  ports         = each.value["ports"]
  instance_type = each.value["instance_type"]

  vpc_id       = module.vpc["main"].vpc_id
  zone_id      = var.zone_id
  bastion_host = var.bastion_host
  subnet_ids   = module.vpc["main"].subnets["app"].subnets
}


module "web" {
  depends_on = [module.app]

  source   = "./modules/ec2"
  for_each = var.web_servers

  component_name = each.key

  env           = var.env
  vault_token   = var.vault_token
  ports         = each.value["ports"]
  instance_type = each.value["instance_type"]

  vpc_id       = module.vpc["main"].vpc_id
  zone_id      = var.zone_id
  bastion_host = var.bastion_host
  subnet_ids   = module.vpc["main"].subnets["web"].subnets
}