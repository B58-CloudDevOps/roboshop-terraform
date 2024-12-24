data "external" "oidc_thumbprint" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", aws_eks_cluster.main.identity[0].oidc[0].issuer]
}

data "aws_caller_identity" "current" {}
