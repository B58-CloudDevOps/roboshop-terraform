resource "aws_instance" "name" {
  count                  = length(var.components)
  ami                    = data.aws_ami.main.image_id
  instance_type          = "t3.small"
  vpc_security_group_ids = ["aws_security_group.main.*.id[count.index]"]

  tags = {
    Name = "${var.components[count.index]}-${var.env}"
  }
}


