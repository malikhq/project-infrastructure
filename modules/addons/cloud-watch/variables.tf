variable "cluster_name" {
  description = "The name of the EKS cluster where the CloudWatch addon will be installed"
  type        = string
}

variable "addon_name" {
  description = "The name of the EKS addon to install"
  type        = string
}