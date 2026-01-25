output "vpc_name" {
  description = "The name of the VPC"
  value       = module.vpc.vpc_name

}
output "cluster_endpoint" {
  description = "The endpoint for the EKS cluster"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "addon_name" {
  description = "The name of the CloudWatch addon installed on the EKS cluster"
  value       = module.cloudwatch.addon_name
}