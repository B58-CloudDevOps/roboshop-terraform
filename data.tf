data "aws_ami" "main" {
  most_recent = true
  name_regex  = "DevOps-LabImage-RHEL9"
  owners      = ["355449129696"]
}

# Get SSH Info
data "vault_generic_secret" "ssh" {
  path = "common/ssh-creds"
}