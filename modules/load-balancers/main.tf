#  Provisions ALB
resource "aws_lb" "test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.main.id]
  subnets            = var.subnet_ids

  tags = {
    Environment = "${var.component_name}-${var.env}-lb"
  }
}

