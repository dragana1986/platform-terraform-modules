variable "name" {
  description = "Name used for the VPC and as a prefix for related resources"
  type        = string
}

variable "cidr_block" {
  description = "IPv4 CIDR block for the VPC, for example 10.0.0.0/16"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "The CIDR block must be a valid IPv4 CIDR, for example 10.0.0.0/16."
  }
}

variable "tags" {
  description = "Additional tags to apply to all resources created by this module"
  type        = map(string)
  default     = {}
}

variable "availability_zones" {
  description = "Availability zones for the subnets, in the same order as the subnet CIDR lists"
  type        = list(string)
  default     = []
}

variable "public_subnet_cidrs" {
  description = "IPv4 CIDR blocks for the public subnets, in the same order as the availability zones"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.public_subnet_cidrs) == 0 || length(var.public_subnet_cidrs) == length(var.availability_zones)
    error_message = "public_subnet_cidrs must have one CIDR block for each Availability Zone in availability_zones."
  }
}

variable "private_app_subnet_cidrs" {
  description = "IPv4 CIDR blocks for the private application subnets, in the same order as the availability zones"
  type        = list(string)
  default     = []

  validation {
    condition     = length(var.private_app_subnet_cidrs) == 0 || length(var.private_app_subnet_cidrs) == length(var.availability_zones)
    error_message = "private_app_subnet_cidrs must have one CIDR block for each Availability Zone in availability_zones."
  }
}

variable "nat_gateway_mode" {
  description = "NAT gateway layout for the private subnets: none, single, or one_per_az"
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "single", "one_per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be one of: none, single, one_per_az."
  }

  validation {
    condition     = var.nat_gateway_mode == "none" || length(var.public_subnet_cidrs) > 0
    error_message = "nat_gateway_mode requires public_subnet_cidrs, because NAT gateways are placed in public subnets."
  }
}
