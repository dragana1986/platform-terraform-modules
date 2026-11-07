# Auto Scaling Group Module

Creates the application server tier: an Auto Scaling group that runs instances from a launch template in private subnets, behind an existing Application Load Balancer. It includes:

- A security group that allows the application port only from the load balancer's security group, and HTTPS outbound
- An IAM role with an instance profile, granting Session Manager access and read access to the application package in S3
- A launch template based on the latest Amazon Linux 2023 image, with IMDSv2 required and an encrypted root volume
- An Auto Scaling group that registers instances in the load balancer's target group, replaces unhealthy instances, and performs rolling instance refreshes with automatic rollback
- A target tracking scaling policy on average CPU utilization

The instances require private subnets in at least two Availability Zones, with outbound internet access through a NAT gateway.

## Usage

```hcl
module "app_servers" {
  source = "git::ssh://git@github.com/dragana1986/platform-terraform-modules.git//auto-scaling-group?ref=v1.4.0"

  name                   = "techmax-dev"
  vpc_id                 = module.vpc.vpc_id
  private_app_subnet_ids = module.vpc.private_app_subnet_ids
  alb_security_group_id  = module.alb.security_group_id
  target_group_arn       = module.alb.target_group_arn
  app_port               = module.alb.target_port
  artifact_bucket_arn    = aws_s3_bucket.artifacts.arn
  user_data              = templatefile("${path.module}/../../../scripts/deploy.sh", { ... })

  tags = {
    Environment = "dev"
  }
}
```
## Inputs

| Name | Description | Type | Default | Required |
|---|---|---|---|---|
| name | The name prefix for the application servers and related resources. | string | n/a | yes |
| vpc_id | The ID of the VPC in which the application servers' security groups will be created. | string | n/a | yes |
| private_app_subnet_ids | The IDs of the private subnets in which the application servers are launched, one per Availability Zone. At least two are required. | list(string) | n/a | yes |
| alb_security_group_id | The ID of the security group attached to the Application Load Balancer. Used as the only permitted source of application traffic. | string | n/a | yes |
| target_group_arn | The ARN of the target group of the Application Load Balancer. Used to register the application servers as targets. | string | n/a | yes |
| user_data | The startup script that installs and starts the application on each application server at first boot. | string | n/a | yes |
| artifact_bucket_arn | The ARN of the S3 bucket that stores the application package. Used to grant the application servers read-only access to that bucket. | string | n/a | yes |
| app_port | The port on which the application servers receive traffic from the Application Load Balancer. | number | 80 | no |
| instance_type | The EC2 instance type for the application servers. | string | "t3.micro" | no |
| min_size | The minimum number of the application servers in the Auto Scaling group. | number | 2 | no |
| max_size | The maximum number of the application servers in the Auto Scaling group. | number | 4 | no |
| desired_capacity | The number of application servers that the Auto Scaling group runs when it is created. | number | 2 | no |
| ebs_volume_size | The size of the root EBS volume attached to each application server, in GiB. Must be at least 8 GiB. | number | 8 | no |
| metadata_hop_limit | The hop limit for instance metadata token responses. Use 1 for applications that run directly on the instance, and 2 for applications that run in containers on the instance. | number | 1 | no |
| cpu_target_value | The target average CPU utilization, in percent, that the scaling policy keeps the application servers at. | number | 50 | no |
| tags | Additional tags to apply to all resources created by this module. | map(string) | {} | no |

## Outputs

| Name | Description |
|---|---|
| auto_scaling_group_name | The name of the Auto Scaling group that runs the application servers. |
| security_group_id | The ID of the security group attached to the application servers. Used as the permitted source in the security groups of resources that servers connect to. |
| instance_role_name | The name of the IAM role assumed by the application servers. Used to attach additional permissions that the application needs. |

## Design notes

- The instances run in private subnets and accept the application port only from the load balancer's security group, so they can't be reached directly from the internet.
- The instance image is resolved from the public SSM parameter for the latest Amazon Linux 2023 x86_64 image. The image architecture must match the instance type, so an ARM instance type such as t4g would also require the arm64 parameter.
- IMDSv2 is required, and the root volume is always encrypted and deleted on termination. These settings are fixed in the module, so no consumer can weaken them.
- Outbound HTTPS is allowed to any address, because the instances reach AWS public endpoints and package repositories that have no fixed IP ranges. The Trivy check AVD-AWS-0104 is suppressed on that rule with an inline comment that records the reason. Production can narrow the rule with VPC endpoints.
- Instance and volume tags are set through the launch template's tag specifications, because the provider's default tags don't reach instances launched by the Auto Scaling group. Pass the environment's tags through the `tags` input.
- The Auto Scaling group uses the load balancer's health check, so it replaces instances whose application stops responding, not only instances with failed hardware.
- A launch template change starts a rolling instance refresh that keeps 100 percent of the desired capacity healthy, launches replacements first, and rolls back automatically if the new instances fail their health checks.
- Terraform ignores later changes to the desired capacity, so an apply never undoes a decision of the scaling policy.
