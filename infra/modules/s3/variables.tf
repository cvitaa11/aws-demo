variable "environment" {
  type        = string
  description = "Environment name"
}

variable "repository" {
  type        = string
  description = "Repository URL for resource tagging"
}

variable "bucket_name" {
  type        = string
  description = "Name of the S3 bucket"
}

variable "enable_versioning" {
  type        = bool
  description = "Enable S3 bucket versioning"
  default     = true
}

variable "enable_replication" {
  type        = bool
  description = "Enable Cross-Region Replication for disaster recovery"
  default     = false
}

variable "replication_region" {
  type        = string
  description = "Region for S3 bucket replication"
  default     = "eu-west-1"
}

variable "lifecycle_rules" {
  type = list(object({
    prefix          = string
    enabled         = bool
    days_to_ia      = number
    days_to_glacier = number
  }))
  description = "Lifecycle rules for S3 bucket"
  default = [{
    prefix          = ""
    enabled         = true
    days_to_ia      = 90
    days_to_glacier = 180
  }]
}
