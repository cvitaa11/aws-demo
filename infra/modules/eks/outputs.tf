output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_ca_certificate" {
  description = "The CA certificate for the EKS cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
}

output "node_security_group_id" {
  description = "Security group ID for the EKS worker nodes"
  value       = aws_security_group.nodes.id
}

output "node_role_arn" {
  description = "IAM role ARN for the EKS worker nodes"
  value       = aws_iam_role.node.arn
}

output "cluster_security_group_id" {
  description = "Security group ID for the EKS cluster control plane"
  value       = aws_security_group.cluster.id
}
