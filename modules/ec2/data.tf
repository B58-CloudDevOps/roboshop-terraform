data "aws_ami" "main" {
  most_recent = true
  name_regex  = "b58-golden-image"
  owners      = ["355449129696"]
  filters = [
    {
      name   = "tag:Version"
      values = ["1.0.0"] # Use a specific version tag
    }
  ]
}

data "vault_generic_secret" "ssh" {
  path = "common/ssh-creds"
}