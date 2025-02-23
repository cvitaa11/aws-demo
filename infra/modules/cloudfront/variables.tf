variable "environment" {
  type        = string
  description = "Environment name"
}

variable "repository" {
  type        = string
  description = "Repository URL for resource tagging"
}

variable "s3_origin_bucket" {
  type        = string
  description = "S3 bucket name for the origin"
}

variable "s3_origin_bucket_regional_domain" {
  type        = string
  description = "S3 bucket regional domain name"
}

variable "price_class" {
  type        = string
  description = "CloudFront price class"
  default     = "PriceClass_100"
}

variable "custom_domain_name" {
  type        = string
  description = "Custom domain name for CloudFront"
  default     = null
}

variable "acm_certificate_arn" {
  type        = string
  description = "ACM certificate ARN for custom domain"
  default     = null
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 bucket"
}

variable "geo_restriction_type" {
  type        = string
  description = "Type of geo restriction (whitelist or blacklist)"
  default     = "none"
}

variable "geo_restriction_locations" {
  type        = list(string)
  description = "List of country codes for geo restriction"
  default     = []
}

variable "web_acl_arn" {
  type        = string
  description = "ARN of WAF Web ACL to associate with the distribution"
  default     = null
}
