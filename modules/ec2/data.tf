data "aws_ami" "main" {
  most_recent = true
  name_regex  = "b58-golden-image"
  owners      = ["355449129696"]
}

data "vault_generic_secret" "ssh" {
  path = "common/ssh-creds"
}