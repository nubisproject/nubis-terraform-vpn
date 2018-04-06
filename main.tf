provider "aws" {
  version = "~> 0.1"
  region  = "${var.region}"
}

provider "local" {
  version = "~> 0.1"
}

resource "aws_vpn_gateway" "vpn_gateway" {
  count = "${var.enabled * length(var.arenas)}"

  lifecycle {
    create_before_destroy = true
  }

  vpc_id = "${element(split(",", var.vpc_id), count.index)}"

  tags {
    Name             = "${var.region}-${element(var.arenas, count.index)}-vpn-gateway"
    ServiceName      = "${var.account_name}"
    TechnicalContact = "${var.technical_contact}"
    Arena            = "${element(var.arenas, count.index)}"
  }
}

resource "aws_customer_gateway" "customer_gateway" {
  count = "${var.enabled * length(split(",", var.vpn_bgp_asn))}"

  lifecycle {
    create_before_destroy = true
  }

  bgp_asn = "${element(split(",", var.vpn_bgp_asn), count.index)}"

  ip_address = "${element(split(",", var.ipsec_target), count.index)}"
  type       = "ipsec.1"

  tags {
    Name             = "${var.region}-customer-gateway"
    ServiceName      = "${var.account_name}"
    TechnicalContact = "${var.technical_contact}"
  }
}

resource "aws_vpn_connection" "main" {
  count = "${var.enabled * length(var.arenas) * length(split(",", var.vpn_bgp_asn))}"

  lifecycle {
    create_before_destroy = true
  }

  vpn_gateway_id      = "${element(aws_vpn_gateway.vpn_gateway.*.id, count.index)}"
  customer_gateway_id = "${element(aws_customer_gateway.customer_gateway.*.id, count.index)}"
  type                = "${element(aws_customer_gateway.customer_gateway.*.type, count.index)}"
  static_routes_only  = false

  tags {
    Name             = "${var.region}-${element(var.arenas, count.index)}-vpn"
    ServiceName      = "${var.account_name}"
    TechnicalContact = "${var.technical_contact}"
    Arena            = "${element(var.arenas, count.index)}"
  }
}

resource "aws_route" "vpn-public" {
  count = "${var.enabled * length(var.arenas) * (length(var.public_route_table_id) >= 1 ? 1 : 0)}"

  lifecycle {
    create_before_destroy = true
  }

  route_table_id         = "${element(split(",", var.public_route_table_id), count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${element(aws_vpn_gateway.vpn_gateway.*.id, count.index)}"
}

resource "aws_route" "vpn-private" {
  count = "${3 * var.enabled * length(var.arenas) * (length(var.private_route_table_id) >= 1  ? 1 : 0)}"

  lifecycle {
    create_before_destroy = true
  }

  route_table_id         = "${element(split(",", var.private_route_table_id), count.index)}"
  destination_cidr_block = "${var.destination_cidr_block}"
  gateway_id             = "${element(aws_vpn_gateway.vpn_gateway.*.id, count.index/3)}"
}

resource "local_file" "vpn_config" {
  count    = "${var.enabled * length(var.arenas) * var.output_config}"
  content  = "${element(concat(aws_vpn_connection.main.*.customer_gateway_configuration, list("")), 0)}"
  filename = "${path.cwd}/${element(aws_vpn_connection.main.*.id, count.index)}-config-${var.account_name}-${var.region}.txt"
}
