resource "aws_eks_cluster" "this" {
  name     = "${var.environment}-eks"
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.cluster.id]
  }

  encryption_config {
    provider {
      key_arn = aws_kms_key.eks.arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = {
    Name        = "${var.environment}-eks"
    Environment = var.environment
    Repository  = var.repository
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_cloudwatch_log_group.eks
  ]
}

resource "aws_kms_key" "eks" {
  description         = "EKS Secret Encryption Key"
  enable_key_rotation = true

  tags = {
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.environment}-eks/cluster"
  retention_in_days = var.environment == "prod" ? 90 : 30

  tags = {
    Environment = var.environment
    Repository  = var.repository
  }
}
