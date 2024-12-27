resource "aws_opensearch_domain" "main" {
  domain_name    = "${var.component_name}-${var.env}"
  engine_version = var.engine_version

  cluster_config {
    instance_type = var.instance_type
  }

  advanced_security_options {
    enabled                        = true
    anonymous_auth_enabled         = false
    internal_user_database_enabled = true
    master_user_options {
      master_user_name     = data.vault_generic_secret.opensearch.data["MASTER_USERNAME"]
      master_user_password = data.vault_generic_secret.opensearch.data["MASTER_PASSWORD"]
    }
  }
  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }
  ebs_options {
    ebs_enabled = true
    volume_size = 20
  }
  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  access_policies = data.aws_iam_policy_document.main.json

  tags = {
    Domain = "${var.component_name}-${var.env}"
  }
}