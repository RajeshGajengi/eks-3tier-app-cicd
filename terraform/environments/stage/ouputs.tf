output "cluster_name" {
  value = module.eks-cluster.eks_cluster_name
}

output "node_name" {
    value = module.eks-nodes.eks_node_group_name
}

output "region" {
  value = module.eks-cluster.region
}

output "vpc_tag" {
  value = module.vpc.vpc_tags
}

output "private_subnet_tags" {
  value = module.subnet.public_subnet_tags
}

output "public_subnet_tags" {
  value = module.subnet.public_subnet_tags
}