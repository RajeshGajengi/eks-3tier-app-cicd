environment = "dev"
instance_type = "t2.micro"
key_name = "project"
ami = "ami-0360c520857e3138f"

# EKS VPC and Subnets Variables
vpc_cidr_block = "123.10.0.0/20" # 4k ips

public_subnets = {
  public1 = { cidr = "123.10.0.0/22", az = "us-east-1a" } # 1k ip x 4 = 4k
  public2 = { cidr = "123.10.4.0/22", az = "us-east-1b" } 
}

private_subnets = {
  private1 = { cidr = "123.10.8.0/22", az = "us-east-1a" }
  private2 = { cidr = "123.10.12.0/22", az = "us-east-1b" }
}


# Cluster and Node Group Variables
region         = "us-east-1"
cluster_name   = "mycluster"
node_group_name = "mynode"

# Scaling Configuration for Node Group
desired_size   = 1
max_size       = 1
min_size       = 1



## RDS variables
db_name = "student_db"
username = "admin"
password = "Rajesh1234"


