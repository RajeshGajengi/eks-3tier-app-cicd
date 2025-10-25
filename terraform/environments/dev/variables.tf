variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, stage, prod)"
}

## Region
variable "region" {
  description = "AWS region for the deployment"
  type        = string
}

## EC2 varibale
variable "instance_type" {
  type = string
  description = "instance type"
}

variable "key_name" {
  type = string
  description = "Key pair"
}

variable "ami" {
  type = string
  description = "ami id"
}


# VPC and Subnet Variables

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnets" {
  description = "Map of public subnet CIDRs with Availability Zones"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  description = "Map of private subnet CIDRs with Availability Zones"
  type = map(object({
    cidr = string
    az   = string
  }))
}


# Cluster and Nodes

variable "cluster_name" {
  description = "Name of the EKS Cluster"
  type        = string
}

variable "node_group_name" {
  description = "Name of the EKS Node Group"
  type        = string
}

variable "desired_size" {
  description = "Desired number of nodes in the node group"
  type        = number
}

variable "max_size" {
  description = "Maximum number of nodes in the node group"
  type        = number
}

variable "min_size" {
  description = "Minimum number of nodes in the node group"
  type        = number
}


## RDS Variable
variable "db_name" {
  type = string
  description = "Name of database instance"
}

variable "username" {
  type = string
  description = "name of user"
}

variable "password" {
  type = string
  description = "password of user"
}

