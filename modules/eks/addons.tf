resource "aws_eks_addon" "addons" {
  for_each                    = var.addons
  cluster_name                = aws_eks_cluster.main.name
  addon_name                  = each.key
  addon_version               = each.value["addon_version"]
  resolve_conflicts_on_update = each.value["resolve_conflicts_on_update"]
}
