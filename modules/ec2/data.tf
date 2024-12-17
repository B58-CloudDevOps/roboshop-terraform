data "aws_ami" "main" {
  most_recent = true
  name_regex  = "b58-golden-image"
  owners      = ["355449129696"]
}