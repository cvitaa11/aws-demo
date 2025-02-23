output "cluster_endpoint" {
  description = "Aurora cluster endpoint"
  value       = aws_rds_cluster.aurora.endpoint
}

output "cluster_reader_endpoint" {
  description = "Aurora cluster reader endpoint"
  value       = aws_rds_cluster.aurora.reader_endpoint
}

output "database_name" {
  description = "Name of the default database"
  value       = var.database_name
}

output "master_username" {
  description = "Master username for IAM authentication"
  value       = var.master_username
}

output "db_access_role_arn" {
  description = "ARN of the IAM role for database access"
  value       = aws_iam_role.aurora_access.arn
}

output "cluster_resource_id" {
  description = "The Resource ID of the cluster"
  value       = aws_rds_cluster.aurora.cluster_resource_id
}
