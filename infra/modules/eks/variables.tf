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
  description = "VPC ID where EKS cluster will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS cluster and node groups"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for EKS cluster"
  default     = "1.28"
}

variable "node_groups" {
  type = map(object({
    desired_size   = number
    min_size       = number
    max_size       = number
    instance_types = list(string)
    capacity_type  = string
    disk_size      = optional(number, 50)
  }))
  description = "Map of EKS managed node group configurations"
}

variable "enable_cluster_autoscaler" {
  type        = bool
  description = "Enable cluster autoscaler"
  default     = true
}
