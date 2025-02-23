resource "aws_security_group" "cluster" {
  name        = "${var.environment}-eks-cluster"
  description = "Security group for EKS cluster control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    self      = true
  }

  tags = {
    Name        = "${var.environment}-eks-cluster"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_security_group" "nodes" {
  name        = "${var.environment}-eks-nodes"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-eks-nodes"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_security_group_rule" "nodes_cluster_inbound" {
  description              = "Allow worker nodes to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.nodes.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_nodes_inbound" {
  description              = "Allow cluster control plane to communicate with worker nodes"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nodes.id
  source_security_group_id = aws_security_group.cluster.id
  to_port                  = 65535
  type                     = "ingress"
}
