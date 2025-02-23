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
  description = "VPC ID where Aurora cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for Aurora cluster"
}

variable "instance_class" {
  type        = string
  description = "Aurora instance class"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Aurora cluster"
}

variable "allowed_security_group_ids" {
  type        = list(string)
  description = "List of security group IDs allowed to access Aurora"
}

variable "database_name" {
  type        = string
  description = "Name of the default database"
}

variable "master_username" {
  type        = string
  description = "Master username"
}

variable "backup_retention_period" {
  type        = number
  description = "Backup retention period in days"
  default     = 7
}

variable "allowed_iam_arns" {
  type        = list(string)
  description = "List of IAM ARNs allowed to assume the database access role"
}
