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
    "dispatchh"
  ]
}

variable "env" {}
variable "vault_token" {}