variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to associate the EKS cluster with"
}

variable "eks_version" {
  type        = string
  default     = "1.31"
  description = "The EKS cluster version to deploy"
}

variable "public_subnet_ids" {
  type = list(string)
  description = "list the subnets ids"
}
