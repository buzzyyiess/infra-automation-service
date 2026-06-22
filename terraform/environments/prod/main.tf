module "s3_assets" {
  source         = "../../modules/s3"
  environment    = "prod"
  cluster_prefix = "tripla-static-assets"
}

# Consumer instance block pulling down the root eks module configuration
module "eks_cluster" {
  source = "../../modules/eks"

  environment    = "prod"
  cluster_prefix = "tripla-eks"
  vpc_id         = "vpc-98765432prodVPC"
  subnet_ids     = ["subnet-prodPrivate1", "subnet-prodPrivate2", "subnet-prodPrivate3"]

  node_instance_type    = "t3.medium" # t-series are generally not preffered on prod we can use r5 or m6g series.
  node_desired_capacity = 5
  node_min_capacity     = 3
  node_max_capacity     = 10
}

output "cluster_endpoint" {
  value       = module.eks_cluster.cluster_endpoint
  description = "The root environment access endpoint URL for cluster orchestration"
}