output "vpn_gateway_id" {
  description = "The ID of the VPN gateway"
  value       = "${element(concat(aws_vpn_gateway.vpn_gateway.*.id, list("")), 0)}"
}

output "vpn_customer_gateaway_id" {
  value = "${element(concat(aws_customer_gateway.customer_gateway.*.id, list("")), 0)}"
}
