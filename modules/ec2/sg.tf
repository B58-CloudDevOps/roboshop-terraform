resource "aws_security_group" "main" {
  name        = "${var.component_name}-${var.env}-sg"
  description = "${var.component_name}-${var.env}-sg"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.component_name}-${var.env}-sg"
  }
}
