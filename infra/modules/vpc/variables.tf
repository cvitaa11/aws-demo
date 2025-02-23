variable "environment" {
  type        = string
  description = "Environment name (e.g., prod, staging, dev)"
}

variable "repository" {
  type        = string
  description = "Repository URL for resource tagging"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for VPC"
}

variable "enable_flow_logs" {
  type        = bool
  description = "Enable VPC Flow Logs"
  default     = true
}

variable "vpc_flow_logs_retention" {
  type        = number
  description = "VPC Flow Logs retention in days"
  default     = 7
}
