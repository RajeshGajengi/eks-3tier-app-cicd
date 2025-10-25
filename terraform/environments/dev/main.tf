provider "aws" {
  region = var.region
}

module "vpc" {
  source          = "../../modules/vpc"
  vpc_cidr_block  = var.vpc_cidr_block
  environment     = var.environment
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "eks-cluster" {
  source        = "../../modules/eks-cluster"
  environment   = var.environment
  cluster_name  = var.cluster_name
  vpc_id        = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  depends_on = [module.vpc]
}

module "eks-nodes" {
  source          = "../../modules/eks-nodes"
  node_group_name = var.node_group_name
  cluster_name    = module.eks-cluster.eks_cluster_name
  vpc_id          = module.vpc.vpc_id
  private_subnet_ids  = module.vpc.private_subnet_ids
  environment     = var.environment
  desired_size    = var.desired_size
  max_size        = var.max_size
  min_size        = var.min_size
  depends_on = [module.vpc]
}

module "ec2" {
 source = "../../modules/ec2"
 instance_type = var.instance_type
 environment = var.environment
 key_name = var.key_name
 vpc_id = module.vpc.vpc_id
 public_subnet = module.vpc.public_subnet_ids[1]
 ami = var.ami
 depends_on = [ module.eks-cluster,module.eks-nodes ]
}

module "rds" {
  source = "../../modules/rds"
  vpc_id = module.vpc.vpc_id
  environment = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
  db_name = var.db_name
  username = var.username
  password = var.password
  depends_on = [ module.eks-cluster,module.eks-nodes ]
  }


