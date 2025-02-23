resource "aws_elasticache_replication_group" "redis" {
  replication_group_id       = "${var.environment}-redis"
  description                = "Redis cluster for ${var.environment}"
  node_type                  = var.node_type
  port                       = 6379
  parameter_group_name       = aws_elasticache_parameter_group.redis.name
  automatic_failover_enabled = var.environment == "prod" ? true : false
  multi_az_enabled           = var.environment == "prod" ? true : false
  num_cache_clusters         = var.environment == "prod" ? 2 : 1
  engine                     = "redis"
  engine_version             = var.engine_version
  subnet_group_name          = aws_elasticache_subnet_group.redis.name
  security_group_ids         = [aws_security_group.redis.id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true

  tags = {
    Name        = "${var.environment}-redis"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_elasticache_parameter_group" "redis" {
  family = var.parameter_group_family
  name   = "${var.environment}-redis-params"

  parameter {
    name  = "maxmemory-policy"
    value = "volatile-lru"
  }

  tags = {
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.environment}-redis-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Environment = var.environment
    Repository  = var.repository
  }
}
