variable "environment" {
  type        = string
  description = "Environment name"
}

variable "repository" {
  type        = string
  description = "Repository URL for resource tagging"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ALB will be deployed"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs for ALB"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS listener"
  default     = null
}

variable "target_groups" {
  type = map(object({
    port        = number
    protocol    = string
    target_type = string
    health_check = object({
      path                = string
      healthy_threshold   = number
      unhealthy_threshold = number
      timeout             = number
      interval            = number
    })
  }))
  description = "Map of target group configurations"
}
