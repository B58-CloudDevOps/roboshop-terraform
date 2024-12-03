resource "aws_route53_record" "main" {
  count   = length(var.components)
  zone_id = "Z05544242107X3QLYUZ0E"
  name    = "${var.components[count.index]}-${var.env}"
  type    = "A"
  ttl     = "3"
  records = [aws_instance.main.*.private_ip[count.index]]
}