output "subnets" {
  value = aws_subnet.main.*.id
}
