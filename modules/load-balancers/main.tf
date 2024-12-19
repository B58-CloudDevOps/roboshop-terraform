#  Provisions ALB
resource "aws_lb" "main" {
  name               = "${var.component_name}-${var.env}-lb"
  internal           = var.internal
  load_balancer_type = var.subnet_ids
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnet_ids

  tags = {
    Name = "${var.component_name}-${var.env}-lb"
  }
}

