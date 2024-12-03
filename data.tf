data "aws_ami" "main" {
  most_recent = true
  name_regex  = "DevOps-LabImage-RHEL9"
  owners      = ["355449129696"]
}