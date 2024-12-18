output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnets" {
  value = module.subnets
}

output "hosted_zone_id" {
  value = aws_route53_zone.private.zone_id
}