# Application Load Balancer Module

Creates an internet-facing Application Load Balancer in the given public subnets, with:

- A dedicated security group that allows HTTP on port 80 from the internet and outbound traffic only to the targets' port within the VPC
- A target group with an HTTP health check on a configurable path
- An HTTP listener on port 80 that forwards all requests to the target group

The load balancer requires public subnets in at least two Availability Zones.

## Usage

```hcl
module "alb" {
  source = "git::ssh://git@github.com/dragana1986/platform-terraform-modules.git//alb?ref=v1.4.0"

  name              = "techmax-dev"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
}
```

## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | Name prefix for the load balancer and related resources. Keep it short: AWS limits load balancer and target group names to 32 characters | string | n/a | yes |
| vpc_id | ID of the VPC where the load balancer's security group and target group will be created | string | n/a | yes |
| public_subnet_ids | IDs of the public subnets for the load balancer, one per Availability Zone. At least two subnets are required | list(string) | n/a | yes |
| target_port | Port on which the load balancer forwards traffic to the application servers | number | 80 | no |
| health_check_path | Path that the load balancer requests on each target to check its health. A target must return HTTP 200 to be considered healthy | string | "/" | no |
| tags | Additional tags to apply to all resources created by this module | map(string) | {} | no |

## Outputs

| Name | Description |
|---|---|
| dns_name | DNS name of the load balancer, used to reach the application and as the target of a Route 53 alias record |
| zone_id | Hosted zone ID of the load balancer, required for a Route 53 alias record |
| security_group_id | ID of the load balancer's security group, used as the only allowed source in the application servers security group |
| target_group_arn | ARN of the target group in which the application servers register |
| target_port | Port on which the target group sends traffic to the application servers |

## Design notes

- The load balancer is internet-facing by design. The Trivy check AVD-AWS-0053 is suppressed on this resource with an inline comment that records the reason.
- Invalid HTTP header fields are dropped before requests are forwarded to the targets.
- The listener serves HTTP only. The Trivy check AVD-AWS-0054 is suppressed on the listener until 2027-02-06. HTTPS on port 443 with an ACM certificate, and a redirect from HTTP to HTTPS, will be added when the application has a domain name.
- The health check uses the traffic port, so each target is checked on the port its traffic is sent to.
