variable "environment" {
  type        = string
  description = "Deployment environment (dev/prod)"
}

variable "cluster_prefix" {
  type        = string
  description = "Prefix for globally unique naming"
}