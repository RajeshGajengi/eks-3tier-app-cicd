variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)"
}

variable "instance_tenancy" {
  type        = string
  default     = "default"
  description = "The instance tenancy for the VPC (default or dedicated)"
}


### SUbnets  varibale

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Map of public subnets with AZs"
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
  description = "Map of private subnets with AZs"
}

