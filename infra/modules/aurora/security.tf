resource "aws_security_group" "aurora" {
  name        = "${var.environment}-aurora"
  description = "Security group for Aurora cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
  }

  tags = {
    Name        = "${var.environment}-aurora-sg"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "${var.environment}-aurora"
  subnet_ids = var.subnet_ids

  tags = {
    Name        = "${var.environment}-aurora-subnet-group"
    Environment = var.environment
    Repository  = var.repository
  }
}
