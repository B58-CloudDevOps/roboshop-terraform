variable "components" {
  default = [
    "frontend",
    "mongodb",
    "catalogue",
    "redis",
    "cart",
    "mysql",
    "shipping",
    "rabbitmq",
    "payment",
    "dispatch"
  ]
}

variable "env" {}