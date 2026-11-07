variable "name" {
  description = "The name prefix for the application servers and related resources."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC in which the application servers' security groups will be created."
  type        = string
}

variable "private_app_subnet_ids" {
  description = "The IDs of the private subnets in which the application servers are launched, one per Availability Zone."
  type        = list(string)

  validation {
    condition     = length(var.private_app_subnet_ids) >= 2
    error_message = "private_app_subnet_ids must contain at least two subnets in different Availability Zones."
  }
}

variable "alb_security_group_id" {
  description = "The ID of the security group attached to the Application Load Balancer. Used as the only permitted source of application traffic."
  type        = string
}

variable "target_group_arn" {
  description = "The ARN of the target group of the Application Load Balancer. Used to register the application servers as targets."
  type        = string
}

variable "app_port" {
  description = "The port on which the application servers receive traffic from the Application Load Balancer."
  type        = number
  default     = 80
}

variable "instance_type" {
  description = "The EC2 instance type for the application servers."
  type        = string
  default     = "t3.micro"
}

variable "min_size" {
  description = "The minimum number of the application servers in the Auto Scaling group."
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of the application servers in the Auto Scaling group."
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "The number of application servers that the Auto Scaling group runs when it is created."
  type        = number
  default     = 2
}

variable "user_data" {
  description = "The startup script that installs and starts the application on each application server at first boot."
  type        = string
}

variable "artifact_bucket_arn" {
  description = "The ARN of the S3 bucket that stores the application package. Used to grant the application servers read-only access to that bucket."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "ebs_volume_size" {
  description = "The size of the root EBS volume attached to each application server, in GiB. Must be at least 8 GiB."
  type        = number
  default     = 8

  validation {
    condition     = var.ebs_volume_size >= 8
    error_message = "ebs_volume_size must be at least 8 GiB, the size of the root EBS volume attached to the application servers."
  }
}

variable "metadata_hop_limit" {
  description = "The hop limit for instance metadata token responses. Use 1 for applications that run directly on the instance, and 2 for applications that run in containers on the instance."
  type        = number
  default     = 1

  validation {
    condition     = contains([1, 2], var.metadata_hop_limit)
    error_message = "metadata_hop_limit must be either 1 for applications on the instance, or 2 for applications in containers on the instance."
  }
}

variable "cpu_target_value" {
  description = "The target average CPU utilization, in percent, that the scaling policy keeps the application servers at."
  type        = number
  default     = 50
}
