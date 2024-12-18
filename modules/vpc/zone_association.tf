resource "aws_route53_zone_association" "default" {
  zone_id = aws_route53_zone.private.zone_id
  vpc_id  = var.def_vpc_id
}

resource "aws_route53_zone" "private" {
  name = "roboshop.internal"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}