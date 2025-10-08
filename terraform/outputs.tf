output "cluster_name" {
  value = aws_eks_cluster.mycluster.name
}

output "node_group_name" {
  value = aws_eks_node_group.node_group.node_group_name
}

output "region" {
  value = aws_eks_cluster.mycluster.region
}

