output "vpn_gateway_id" {
  description = "The ID of the VPN gateway"
  value       = "${element(concat(aws_vpn_gateway.vpn_gateway.*.id, list("")), 0)}"
}

output "vpn_customer_gateaway_id" {
  value = "${element(concat(aws_customer_gateway.customer_gateway.*.id, list("")), 0)}"
}

output "vpn_tunnel1_address" {
  value = "${element(concat(aws_vpn_connection.main.*.tunnel1_address, list("")), 0)}"
}

output "vpn_tunnel1_preshared_key" {
  value = "${element(concat(aws_vpn_connection.main.*.tunnel1_preshared_key, list("")), 0)}"
}

output "vpn_tunnel1_bgp_asn" {
  value = "${element(concat(aws_vpn_connection.main.*.tunnel1_bgp_asn, list("")), 0)}"
}

output "vpn_tunnel2_address" {
  value = "${element(concat(aws_vpn_connection.main.*.tunnel2_address, list("")), 0)}"
}

output "vpn_tunnel2_preshared_key" {
  value = "${element(concat(aws_vpn_connection.main.*.tunnel2_preshared_key, list("")), 0)}"
}

output "vpn_tunnel2_bgp_asn" {
  value = "${element(concat(aws_vpn_connection.main.*.tunnel2_bgp_asn, list("")), 0)}"
}
