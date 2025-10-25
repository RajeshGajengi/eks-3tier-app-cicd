environment = "dev"

# VPC and Subnets Variables
vpc_cidr_block = "192.10.0.0/16"

public_subnets = {
  public1 = { cidr = "192.10.1.0/24", az = "us-east-1a" }
  public2 = { cidr = "192.10.2.0/24", az = "us-east-1b" }
}

private_subnets = {
  private1 = { cidr = "192.10.3.0/24", az = "us-east-1a" }
  private2 = { cidr = "192.10.4.0/24", az = "us-east-1b" }
}

# Cluster and Node Group Variables
region         = "ap-south-1"
cluster_name   = "mycluster"
node_group_name = "mynode"

# Scaling Configuration for Node Group
desired_size   = 2
max_size       = 1
min_size       = 1
