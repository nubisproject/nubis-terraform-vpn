# nubis-terraform-vpn

A terraform module creating a vpn connection, this works for a nubis account
and makes several assumptions about how a VPC is configured

## Usage

```bash
module "vpn" {
    source                  = "github.com/nubisproject/nubis-terraform-vpn"
    enabled                 = true
    region                  = "us-west-2"
    arenas                  = [ "core" ]
    account_name            = "account-name-here"
    technical_contact       = "name@example.com"
    vpc_id                  = "vpc-1234,vpc-234"
    vpn_bgp_asn             = "65000"
    ipsec_target            = "<datacenter public IP here>"
    private_route_table_id  = "rtb-1234"
    public_route_table_id   = "rtb-3456"

    # This is optional if you want to print config
    output_config           = true
}
```

## Inputs and Outputs

Inputs:

* `enabled`: Enable this module or not. Default is `1`
* `region`: AWS Region. Default `us-west-2`
* `arenas`: Arena name, nubis specific. Default `core`
* `account_name`: Name of the AWS account
* `technical_contact`: Technical contact. Default `infra-aws@mozilla.com`
* `vpc_id`: Self explanatory VPC ID
* `vpn_bgp_asn`: Gateway's BGP Autonomous System Number(ASN). Default `65000`
* `ipsec_target`: IP address of the remote end
* `private_route_table_id`: Route table ID for private vpc
* `public_route_table_id`: Route table ID for the public vpc
* `output_config`: Optional option, saves config to file. Default `false`

Outputs:

* `vpn_gateway_id`: Gateway ID nothing special
* `vpn_customer_gateaway_id`: Customer gateway ID

