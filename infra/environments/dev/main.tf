module "vpc" {
  source      = "../../modules/vpc"
  environment = local.environment
  repository  = local.repository
  vpc_cidr    = "10.2.0.0/16"
}

module "eks" {
  source      = "../../modules/eks"
  environment = local.environment
  repository  = local.repository
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  cluster_version = "1.28"
  node_groups = {
    general = {
      desired_size   = 2
      min_size       = 1
      max_size       = 3
      instance_types = ["t3.medium"]
      capacity_type  = "SPOT" # Use SPOT for dev to save costs
      disk_size      = 50
    }
  }
}

module "s3" {
  source      = "../../modules/s3"
  environment = local.environment
  repository  = local.repository

  providers = {
    aws             = aws
    aws.replication = aws.replication
  }

  bucket_name        = "dev-static-content-12345"
  enable_versioning  = true
  enable_replication = false # No replication needed in dev

  lifecycle_rules = [{
    prefix          = ""
    enabled         = true
    days_to_ia      = 30
    days_to_glacier = 60
  }]
}

module "cloudfront" {
  source      = "../../modules/cloudfront"
  environment = local.environment
  repository  = local.repository

  s3_origin_bucket                 = module.s3.bucket_id
  s3_origin_bucket_regional_domain = module.s3.bucket_regional_domain_name
  s3_bucket_arn                    = module.s3.bucket_arn
  price_class                      = "PriceClass_100" # Cheapest option for dev
}

module "aurora" {
  source      = "../../modules/aurora"
  environment = local.environment
  repository  = local.repository

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  cluster_name    = "dev-main"
  database_name   = "appdb"
  master_username = "admin"
  instance_class  = "db.t4g.medium" # Cost-effective option for dev

  allowed_security_group_ids = [module.eks.node_security_group_id]
  allowed_iam_arns           = [module.eks.node_role_arn]
}

module "redis" {
  source      = "../../modules/elasticache"
  environment = local.environment
  repository  = local.repository

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  node_type  = "cache.t4g.micro" # Smallest instance for dev

  allowed_security_group_ids = [module.eks.node_security_group_id]
}

module "alb" {
  source      = "../../modules/alb"
  environment = local.environment
  repository  = local.repository

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  target_groups = {
    default = {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
      health_check = {
        path                = "/health"
        healthy_threshold   = 2
        unhealthy_threshold = 3
        timeout             = 5
        interval            = 30
      }
    }
  }
}
