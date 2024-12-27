data "vault_generic_secret" "opensearch" {
  path = "common/opensearch"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["es:*"]
    resources = ["arn:aws:es:us-east-1:${data.aws_caller_identity.current.account_id}:domain/${var.component_name}-${var.env}/*"]

  }
}