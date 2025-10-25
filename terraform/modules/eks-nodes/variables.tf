# VPC ID to which the node group will be attached
variable "vpc_id" {
  type        = string
  description = "VPC ID where the EKS Node Group is deployed"
}

# The name of the EKS Node Group
variable "node_group_name" {
  type        = string
  description = "Name of the EKS Node Group"
}

# The name of the EKS Cluster from the eks-cluster module
variable "cluster_name" {
  type        = string
  description = "The name of the EKS Cluster"
}

# The environment (dev, staging, prod, etc.)
variable "environment" {
  type        = string
  description = "The environment (e.g., dev, staging, prod)"
}

# Desired number of nodes in the node group
variable "desired_size" {
  type        = number
  description = "Desired size of nodes in the EKS Node Group"
}

# Maximum number of nodes in the node group
variable "max_size" {
  type        = number
  description = "Maximum size of nodes in the EKS Node Group"
}

# Minimum number of nodes in the node group
variable "min_size" {
  type        = number
  description = "Minimum size of nodes in the EKS Node Group"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "List the private subnets ids"
}