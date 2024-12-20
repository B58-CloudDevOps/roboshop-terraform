resource "aws_eks_cluster" "main" {
  name     = "${var.env}-eks"
  role_arn = aws_iam_role.eks_role.arn
  version  = var.eks_cluster_version

  vpc_config {
    subnet_ids = var.subnet_ids
  }
}