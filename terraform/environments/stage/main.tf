provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  environment     = var.environment
}

module "subnet" {
  source          = "../../modules/subnets"
  vpc_id          = module.vpc.vpc_id
  environment     = var.environment
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks-cluster" {
  source        = "../../modules/eks-cluster"
  environment   = var.environment
  cluster_name  = var.cluster_name
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.subnet.public_subnet_ids
}

module "eks-nodes" {
  source          = "../../modules/eks-nodes"
  node_group_name = var.node_group_name
  cluster_name    = module.eks-cluster.eks_cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnet_ids  = module.subnet.private_subnet_ids
  environment     = var.environment
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
}
