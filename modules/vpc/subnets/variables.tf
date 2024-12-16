variable "vpc_id" {}
variable "cidr" {
  type    = string
  default = "172.31.0.0/16"
}
variable "env" {}
variable "availability_zones" {}
variable "name" {}
variable "ngw_ids" {}
variable "vpc_peering_ids" {}