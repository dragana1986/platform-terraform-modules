# VPC Module

Creates an AWS VPC with DNS support and DNS hostnames enabled.

## Usage

```hcl
module "vpc" {
  source = "git::ssh://git@github.com/dragana1986/platform-terraform-modules.git//vpc?ref=v1.0.0"

  name       = "techmax-dev"
  cidr_block = "10.0.0.0/16"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | Name used for the VPC and as a prefix for related resources | string | n/a | yes |
| cidr_block | IPv4 CIDR block for the VPC, for example 10.0.0.0/16 | string | n/a | yes |
| tags | Additional tags to apply to all resources created by this module | map(string) | {} | no |

## Outputs

| Name | Description |
|---|---|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
