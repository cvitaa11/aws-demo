resource "aws_cloudfront_origin_access_control" "this" {
  name                              = "${var.environment}-cf-s3-oac"
  description                       = "Origin Access Control for S3 static content"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = var.environment == "prod" ? "PriceClass_All" : var.price_class

  aliases = var.custom_domain_name != null ? [var.custom_domain_name] : []

  origin {
    domain_name              = var.s3_origin_bucket_regional_domain
    origin_id                = "S3-${var.s3_origin_bucket}"
    origin_access_control_id = aws_cloudfront_origin_access_control.this.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.s3_origin_bucket}"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = var.geo_restriction_type
      locations        = var.geo_restriction_locations
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.custom_domain_name == null
    acm_certificate_arn            = var.custom_domain_name != null ? var.acm_certificate_arn : null
    ssl_support_method             = var.custom_domain_name != null ? "sni-only" : null
    minimum_protocol_version       = var.custom_domain_name != null ? "TLSv1.2_2021" : "TLSv1"
  }

  web_acl_id = var.web_acl_arn

  tags = {
    Name        = "${var.environment}-cloudfront"
    Environment = var.environment
    Repository  = var.repository
  }
}
