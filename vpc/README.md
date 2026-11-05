# VPC Module

Creates an AWS VPC with DNS support and DNS hostnames enabled, and optionally:

- Public subnets with one shared public route table and an internet gateway
- Private application subnets with one route table per Availability Zone
- NAT gateways with Elastic IPs for outbound internet access from the private subnets

Each subnet list takes one CIDR block per Availability Zone, in the same order as `availability_zones`.

## Usage

```hcl
module "vpc" {
  source = "git::ssh://git@github.com/dragana1986/platform-terraform-modules.git//vpc?ref=v1.3.0"

  name       = "techmax-dev"
  cidr_block = "10.10.0.0/16"

  availability_zones       = ["us-east-1a", "us-east-1b"]
  public_subnet_cidrs      = ["10.10.1.0/24", "10.10.2.0/24"]
  private_app_subnet_cidrs = ["10.10.11.0/24", "10.10.12.0/24"]

  nat_gateway_mode = "single"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | Name used for the VPC and as a prefix for related resources | string | n/a | yes |
| cidr_block | IPv4 CIDR block for the VPC, for example 10.0.0.0/16 | string | n/a | yes |
| tags | Additional tags to apply to all resources created by this module | map(string) | {} | no |
| availability_zones | Availability Zones for the subnets, in the same order as the subnet CIDR lists | list(string) | [] | no |
| public_subnet_cidrs | IPv4 CIDR blocks for the public subnets, one per Availability Zone. Creates the internet gateway and the public route table when not empty | list(string) | [] | no |
| private_app_subnet_cidrs | IPv4 CIDR blocks for the private application subnets, one per Availability Zone. Creates one private route table per subnet | list(string) | [] | no |
| nat_gateway_mode | NAT gateway layout for the private subnets: none, single, or one_per_az. Requires public_subnet_cidrs | string | "none" | no |

## NAT gateway modes

| Mode | NAT gateways | Outbound access if one Availability Zone fails | Typical use |
|---|---|---|---|
| none | 0 | Private subnets have no internet access | Workloads that only use VPC endpoints, or no outbound access |
| single | 1, in the first public subnet | Lost in every Availability Zone if the NAT gateway's zone fails | Development and test environments |
| one_per_az | 1 per public subnet | The other Availability Zones keep outbound access | Production |

Each NAT gateway is charged per hour and per gigabyte of processed data, so `one_per_az` costs about twice as much as `single` with two Availability Zones.

## Outputs

| Name | Description |
|---|---|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| public_subnet_ids | The IDs of the public subnets, in the same order as the availability zones |
| public_subnet_cidrs | The CIDR blocks of the public subnets, in the same order as the availability zones |
| private_app_subnet_ids | The IDs of the private application subnets, in the same order as the availability zones |
| private_app_subnet_cidrs | The CIDR blocks of the private application subnets, in the same order as the availability zones |
| internet_gateway_id | The ID of the internet gateway, or null when the VPC has no public subnets |
| nat_gateway_public_ips | The public IP addresses of the NAT gateways. Outbound traffic from the private subnets uses these addresses, so partners add them to their allow-lists |
| nat_gateway_ids | The IDs of the NAT gateways, used for CloudWatch alarms on NAT gateway metrics |
| public_route_table_id | The ID of the public route table, or null when the VPC has no public subnets. Used to attach VPC gateway endpoints |
| private_app_route_table_ids | The IDs of the private application route tables, in the same order as the availability zones. Used to attach VPC gateway endpoints |
