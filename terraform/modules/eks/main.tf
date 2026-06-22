
# Modernized EKS cluster using upstream v20 specifications
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.cluster_prefix}-${var.environment}"
  cluster_version = "1.33"

  # Network topology bindings
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Security: Enforce private access to kubectl
  cluster_endpoint_public_access  = false
  cluster_endpoint_private_access = true

  # AWS Managed Node Groups configuration
  eks_managed_node_groups = {
    default = {
      min_size       = var.node_min_capacity
      max_size       = var.node_max_capacity
      desired_size   = var.node_desired_capacity
      instance_types = [var.node_instance_type]
      
      labels = {
        Environment = var.environment
      }
    }
  }

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

