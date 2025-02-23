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
  description = "VPC ID where Redis cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Redis cluster"
}

variable "node_type" {
  type        = string
  description = "Redis node instance type"
}

variable "engine_version" {
  type        = string
  description = "Redis engine version"
  default     = "7.0"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs allowed to access Redis"
}

variable "parameter_group_family" {
  type        = string
  description = "Redis parameter group family"
  default     = "redis7"
}
