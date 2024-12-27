resource "aws_opensearch_domain" "main" {
  domain_name    = "${var.component_name}-${var.env}"
  engine_version = var.engine_version

  cluster_config {
    instance_type = var.instance_type
  }

  tags = {
    Domain = "TestDomain"
  }
}
