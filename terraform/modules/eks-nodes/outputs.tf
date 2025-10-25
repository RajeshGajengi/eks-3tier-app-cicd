# The name of the created EKS Node Group
output "eks_node_group_name" {
  description = "The name of the created EKS Node Group"
  value       = aws_eks_node_group.eks_node_group.node_group_name
}

# The ARN of the created EKS Node Group
output "eks_node_group_arn" {
  description = "The ARN of the created EKS Node Group"
  value       = aws_eks_node_group.eks_node_group.arn
}

# The ID of the node IAM Role associated with the EKS Node Group
output "eks_node_group_role_arn" {
  description = "The ARN of the IAM role used by the EKS Node Group"
  value       = aws_iam_role.eks_node_group_role.arn
}


# The scaling configuration for the EKS Node Group
output "eks_node_group_scaling_config" {
  description = "The scaling configuration (desired_size, min_size, max_size) for the EKS Node Group"
  value = {
    desired_size = var.desired_size
    min_size     = var.min_size
    max_size     = var.max_size
  }
}
