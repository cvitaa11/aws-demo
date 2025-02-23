resource "aws_s3_bucket" "replication" {
  count    = var.enable_replication ? 1 : 0
  provider = aws.replication
  bucket   = "${var.bucket_name}-replication"

  tags = {
    Name        = "${var.bucket_name}-replication"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_s3_bucket_replication_configuration" "this" {
  count  = var.enable_replication ? 1 : 0
  bucket = aws_s3_bucket.this.id
  role   = aws_iam_role.replication[0].arn

  rule {
    id     = "replicate-all"
    status = "Enabled"

    destination {
      bucket        = aws_s3_bucket.replication[0].arn
      storage_class = "STANDARD_IA"
    }
  }
}

resource "aws_iam_role" "replication" {
  count = var.enable_replication ? 1 : 0
  name  = "${var.environment}-s3-replication"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = var.environment
    Repository  = var.repository
  }
}
