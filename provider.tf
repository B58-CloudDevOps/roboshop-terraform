terraform {
  backend "s3" {}
}

provider "vault" {
  address         = "https://vault.cloudapps.today:8200/"
  skip_tls_verify = true
  token           = var.vault_token
}

