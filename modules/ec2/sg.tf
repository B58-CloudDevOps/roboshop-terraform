resource "aws_security_group" "main" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "${var.component_name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    cidr_blocks = var.bastion_host
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Dynamic block for ingress rules
  dynamic "ingress" {
    for_each = var.ports
    content {
      description = ingress.key
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = "TCP"
      cidr_blocks = ingress.value["cidr"]
    }
  }
  tags = {
    Name = "${var.component_name}-${var.env}-sg"
  }
}
