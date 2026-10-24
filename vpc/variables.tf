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



