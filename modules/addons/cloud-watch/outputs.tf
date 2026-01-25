output "addon_name" {
  description = "The name of the CloudWatch addon installed on the EKS cluster"
  value       = aws_eks_addon.cloudwatch.addon_name
}