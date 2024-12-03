resource "aws_instance" "name" {
  ami           = data.aws_ami.main.image_id
  instance_type = "t3.small"
}