variable "environment" {
  type        = string
  description = "Environment deployment context name (e.g., dev, prod)"
}

variable "cluster_prefix" {
  type        = string
  description = "Core prefix used to build the canonical cluster name"
}

variable "vpc_id" {
  type        = string
  description = "Target AWS VPC infrastructure network identifier"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Isolated private subnets mapped for worker node execution pools"
}

variable "node_instance_type" {
  type        = string
  description = "EC2 instance family type for compute node workloads"
}

variable "node_desired_capacity" {
  type        = number
  description = "Target headcount of operational active worker nodes"
}

variable "node_min_capacity" {
  type        = number
  description = "Absolute floor boundary limit for auto-scaling contractions"
}

variable "node_max_capacity" {
  type        = number
  description = "Absolute ceiling boundary limit for auto-scaling expansions"
}