module "vpc" {
  source      = "../../modules/vpc"
  environment = local.environment
  repository  = local.repository
  vpc_cidr    = "10.0.0.0/16" # Production CIDR range
}

module "eks" {
  source      = "../../modules/eks"
  environment = local.environment
  repository  = local.repository
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnet_ids

  cluster_version = "1.28"
  node_groups = {
    system = {
      desired_size   = 3
      min_size       = 3
      max_size       = 5
      instance_types = ["m6i.2xlarge"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 100
    },
    application = {
      desired_size   = 5
      min_size       = 3
      max_size       = 10
      instance_types = ["m6i.xlarge"]
      capacity_type  = "ON_DEMAND"
      disk_size      = 100
    },
    batch = {
      desired_size   = 0
      min_size       = 0
      max_size       = 10
      instance_types = ["c6i.2xlarge"]
      capacity_type  = "SPOT"
      disk_size      = 100
    }
  }
}

module "redis" {
  source      = "../../modules/elasticache"
  environment = local.environment
  repository  = local.repository

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids
  node_type  = "cache.r6g.xlarge"

  allowed_security_group_ids = [module.eks.node_security_group_id]
}

module "aurora" {
  source      = "../../modules/aurora"
  environment = local.environment
  repository  = local.repository

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  cluster_name    = "main"
  database_name   = "appdb"
  master_username = "admin"
  instance_class  = "db.r6g.2xlarge"

  allowed_security_group_ids = [module.eks.node_security_group_id]
  allowed_iam_arns           = [module.eks.node_role_arn]
}

module "s3" {
  source      = "../../modules/s3"
  environment = local.environment
  repository  = local.repository

  providers = {
    aws             = aws
    aws.replication = aws.replication
  }

  bucket_name        = "prod-static-content-12345"
  enable_versioning  = true
  enable_replication = true
  replication_region = "eu-west-1"

  lifecycle_rules = [{
    prefix          = ""
    enabled         = true
    days_to_ia      = 90
    days_to_glacier = 180
  }]
}

module "cloudfront" {
  source      = "../../modules/cloudfront"
  environment = local.environment
  repository  = local.repository

  s3_origin_bucket                 = module.s3.bucket_id
  s3_origin_bucket_regional_domain = module.s3.bucket_regional_domain_name
  s3_bucket_arn                    = module.s3.bucket_arn

  price_class         = "PriceClass_All"
  custom_domain_name  = "static.yourdomain.com"
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/xxxxx"
  web_acl_arn         = "arn:aws:wafv2:us-east-1:123456789012:global/webacl/xxxxx"
}

module "alb" {
  source      = "../../modules/alb"
  environment = local.environment
  repository  = local.repository

  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  certificate_arn   = "arn:aws:acm:eu-central-1:123456789012:certificate/xxxxx"

  target_groups = {
    main = {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
      health_check = {
        path                = "/health"
        healthy_threshold   = 3
        unhealthy_threshold = 2
        timeout             = 5
        interval            = 30
      }
    }
  }
}
