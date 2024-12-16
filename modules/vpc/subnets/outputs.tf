output "subnets" {
  value = aws_subnet.main.*.id
}
output "default_vpc_cidr" {
  value = var.def_vpc_cidr
}