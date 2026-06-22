output "cluster_name" {
  value       = module.eks.cluster_name
  description = "Canonical cluster identifier token emitted by AWS EKS"
}

output "cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Secure HTTPS API endpoint URL used for kubectl orchestration"
}