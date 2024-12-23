resource "aws_iam_openid_connect_provider" "main" {
  url = aws_eks_cluster.main.identity.oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [data.external.oidc_thumbprint.result.thumbprint]
}

data "external" "oidc_thumbprint" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", aws_eks_cluster.main.identity[0].oidc[0].issuer]
}