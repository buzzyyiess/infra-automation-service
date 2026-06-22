module "s3_assets" {
  source         = "../../modules/s3"
  environment    = "dev"
  cluster_prefix = "tripla-static-assets"
}

# Consumer instance block pulling down the root eks module configuration
module "eks_cluster" {
  source = "../../modules/eks"

  environment    = "dev"
  cluster_prefix = "tripla-eks"
  vpc_id         = "vpc-01234567devVPC"
  subnet_ids     = ["subnet-devPrivate1", "subnet-devPrivate2"]

  node_instance_type    = "t3.medium"
  node_desired_capacity = 2
  node_min_capacity     = 1
  node_max_capacity     = 3
}


output "cluster_endpoint" {
  value       = module.eks_cluster.cluster_endpoint
  description = "The root environment access endpoint URL for cluster orchestration"
}