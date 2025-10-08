#############################################
# Provider Configuration
#############################################
provider "aws" {
  region = var.region
}

#############################################
# EKS Cluster IAM Role
#############################################
resource "aws_iam_role" "cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com" # EKS will assume this role
        }
      },
    ]
  })
}

# Attach the required policy to the cluster role
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

#############################################
# Networking (using default VPC & subnets)
#############################################

# Fetch default VPC
data "aws_vpc" "default_vpc" {
  default = true
}

# Fetch all subnets inside the default VPC
data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

#############################################
# EKS Cluster Definition
#############################################
resource "aws_eks_cluster" "mycluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster_role.arn
  # version = "1.31"   # Optional: specify EKS version

  vpc_config {
    subnet_ids = slice(data.aws_subnets.default.ids, 0, 2) # Use first 2 subnets (different AZs)
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
  ]
}

#############################################
# EKS Node Group IAM Role
#############################################
resource "aws_iam_role" "nodegroup_role" {
  name = "eks-node-group"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com" # EC2 nodes (workers) assume this role
      }
    }]
  })
}

# Attach required policies for node group role
resource "aws_iam_role_policy_attachment" "nodegroup_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "nodegroup_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "nodegroup_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodegroup_role.name
}

#############################################
# EKS Node Group
#############################################
resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.mycluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.nodegroup_role.arn
  subnet_ids      = data.aws_subnets.default_subnets.ids
  instance_types = [var.instance_type]

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  # Ensure IAM Role permissions exist before node group creation
  depends_on = [
    aws_iam_role_policy_attachment.nodegroup_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodegroup_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.nodegroup_AmazonEC2ContainerRegistryReadOnly,
  ]
}