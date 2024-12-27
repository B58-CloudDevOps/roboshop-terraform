data "external" "oidc_thumbprint" {
  program = ["kubergrunt", "eks", "oidc-thumbprint", "--issuer-url", aws_eks_cluster.main.identity[0].oidc[0].issuer]
}

data "aws_caller_identity" "current" {}

data "vault_generic_secret" "opensearch" {
  path = "common/opensearch"
}

data "template_file" "fluend_values" {
  template = file("${path.module}/conf/fluentd.yaml")
  vars = {
    consul_address  = "${aws_instance.consul.private_ip}"
    DOMAIN_URL      = var.opensearch_url
    DOMAIN_USERNAME = data.vault_generic_secret.opensearch.data["MASTER_USERNAME"]
    DOMAIN_PASSWORD = data.vault_generic_secret.opensearch.data["MASTER_PASSWORD"]

  }
}