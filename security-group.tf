resource "aws_security_group" "main" {
  count = length(var.components)

  name        = "${var.components[count.index]}-${var.env}"
  description = "${var.components[count.index]}-${var.env}"

  ingress {
    description      = "Allows All"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.components[count.index]}-${var.env}"
  }
}