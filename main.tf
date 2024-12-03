resource "aws_instance" "name" {
  count         = length(var.components)
  ami           = data.aws_ami.main.image_id
  instance_type = "t3.small"
}