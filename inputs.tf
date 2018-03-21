variable "region" {
  default = "us-west-2"
}

variable "account_name" {}

variable "technical_contact" {
  default = "infra-aws@mozilla.com"
}

variable "enabled" {
  default = "1"
}

variable "arenas" {
  type = "list"
}

variable "vpc_id" {}

variable "vpn_bgp_asn" {
  default = "65000"
}

variable "public_route_table_id" {}

variable "private_route_table_id" {}

variable "ipsec_target" {}

variable "destination_cidr_block" {
  default = "10.0.0.0/8"
}

variable "output_config" {
  default = false
}
