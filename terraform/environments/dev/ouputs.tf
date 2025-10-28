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

# EC2 IPS
output "master_public_ip" {
  value = module.ec2.master_public_ip
}

output "monitoring_public_ip" {
  value = module.ec2.monitoring_public_ip
}

output "sonarqube_public_ip" {
  value = module.ec2.sonarqube_public_ip
}


## RDS enpoint
output "rds_endpoint" {
  value = module.rds.rds_endpoint
}