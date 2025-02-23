output "bucket_id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the bucket"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}

output "replication_bucket_arn" {
  description = "The ARN of the replication bucket"
  value       = var.enable_replication ? aws_s3_bucket.replication[0].arn : null
}
