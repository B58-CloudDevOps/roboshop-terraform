resource "aws_instance" "main" {
  # ami                    = data.aws_ami.main.image_id
  ami                    = ami-0843b485d2bd433a2
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.main.id]
  subnet_id              = var.subnet_ids[0]

  tags = {
    Name = "${var.component_name}-${var.env}"
  }
}