resource "aws_iam_role" "aurora_access" {
  name = "${var.environment}-aurora-access"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
          AWS     = var.allowed_iam_arns
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_iam_role_policy" "aurora_access" {
  name = "${var.environment}-aurora-connect"
  role = aws_iam_role.aurora_access.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "rds-db:connect"
        ]
        Resource = [
          "arn:aws:rds-db:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:dbuser:${aws_rds_cluster.aurora.cluster_resource_id}/${var.master_username}"
        ]
      }
    ]
  })
}

data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
