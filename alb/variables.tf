variable "name" {
  description = "Name prefix for the load balancer and related resources. Keep it short: AWS limits load balancer and target group names to 32 characters"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the load balancer's security group and target group will be created"
  type        = string
}

variable "public_subnet_ids" {
  description = "IDs of the public subnets for the load balancer, one per Availability Zone. At least two subnets are required"
  type        = list(string)

  validation {
    condition     = length(var.public_subnet_ids) >= 2
    error_message = "public_subnet_ids must contain at least two subnets in different Availability Zones."
  }
}

variable "target_port" {
  description = "Port on which the load balancer forwards traffic to the application servers"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path that the load balancer requests on each target to check its health. A target must return HTTP 200 to be considered healthy"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Additional tags to apply to all resources created by this module"
  type        = map(string)
  default     = {}
}
