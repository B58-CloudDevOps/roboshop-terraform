# resource "aws_route53_zone_association" "main" {
#   zone_id = var.zone_id
#   vpc_id  = aws_vpc.main.id
# }

resource "aws_route53_zone" "private" {
  name = "roboshop.internal"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}