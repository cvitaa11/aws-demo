resource "aws_rds_cluster" "aurora" {
  cluster_identifier  = "${var.environment}-${var.cluster_name}"
  engine              = "aurora-mysql"
  engine_version      = "8.0.mysql_aurora.3.03.1"
  database_name       = var.database_name
  master_username     = var.master_username
  skip_final_snapshot = var.environment != "prod"

  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora.name

  backup_retention_period = var.environment == "prod" ? 30 : var.backup_retention_period
  preferred_backup_window = "03:00-04:00"
  deletion_protection     = var.environment == "prod"
  copy_tags_to_snapshot   = true
  storage_encrypted       = true

  iam_database_authentication_enabled = true

  serverlessv2_scaling_configuration {
    min_capacity = var.environment == "prod" ? 1 : 0.5
    max_capacity = var.environment == "prod" ? 4 : 1
  }

  tags = {
    Name        = "${var.environment}-${var.cluster_name}"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_rds_cluster_instance" "aurora" {
  count = var.environment == "prod" ? 2 : 1

  identifier         = "${var.environment}-${var.cluster_name}-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.aurora.id
  instance_class     = var.instance_class
  engine             = aws_rds_cluster.aurora.engine
  engine_version     = aws_rds_cluster.aurora.engine_version

  auto_minor_version_upgrade   = true
  performance_insights_enabled = true

  tags = {
    Name        = "${var.environment}-${var.cluster_name}-${count.index + 1}"
    Environment = var.environment
    Repository  = var.repository
  }
}
