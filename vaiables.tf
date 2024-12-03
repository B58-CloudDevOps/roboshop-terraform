variable "components" {
  default = [
    "frontend",
    "mongodb",
    "catalogue",
    "user",
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