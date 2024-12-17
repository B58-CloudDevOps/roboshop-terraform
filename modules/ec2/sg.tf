resource "aws_security_group" "main" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "${var.component_name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  tags = {
    Name = "allow_tls"
  }
}