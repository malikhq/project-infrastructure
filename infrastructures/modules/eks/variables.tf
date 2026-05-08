variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "dev-eks-cluster"
}


variable "vpc_id" {
  description = "The ID of the VPC where the EKS cluster will be deployed"
  type        = string
}

variable "private_subnets" {
  description = "The private subnets for the EKS cluster"
  type        = list(string)
}