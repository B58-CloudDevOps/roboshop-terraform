terraform {
  backend "s3" {}
}

provider "vault" {
  address         = "https://vault.roboshop.internal:8200/"
  skip_tls_verify = true
  token           = var.vault_token
}