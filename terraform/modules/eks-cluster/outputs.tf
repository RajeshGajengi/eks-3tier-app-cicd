output "eks_cluster_name" {
   description = "The name of the created EKS cluster"
   value = aws_eks_cluster.eks_cluster.name
}

output "region" {
  value = aws_eks_cluster.eks_cluster.region
}