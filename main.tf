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

module "eks" {
  source              = "./modules/eks"
  for_each            = var.eks
  component_name      = each.key
  env                 = var.env
  subnet_ids          = module.vpc["main"].subnets[each.value["subnet_ref"]].subnets
  eks_cluster_version = each.value["eks_cluster_version"]
  node_groups         = each.value["node_groups"]
  min_nodes           = each.value["min_nodes"]
  max_nodes           = each.value["max_nodes"]
}