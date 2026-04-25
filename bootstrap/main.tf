/**
  * # Main Terraform Configuration
  *
  * This file serves as the entry point for provisioning the EKS cluster and its associated resources. It includes the VPC module for networking, the EKS module for cluster creation, and the Argo CD addon for GitOps deployment.
  *
  * ## Modules
  * - `vpc`: Provisions a Virtual Private Cloud with public and private subnets
  * - `eks`: Creates an EKS cluster with specified configurations and addons
  * - `argo_cd`: Deploys Argo CD using Helm for continuous delivery
  *
  * ## Usage
  * To deploy the infrastructure, run `terraform init` followed by `terraform apply` in the directory containing this configuration.
  */

# Random string resource for generating a unique suffix for the cluster name
resource "random_string" "suffix" {
  length  = 8
  special = false
}

# VPC module
module "vpc" {
  source   = "../modules/vpc"
  vpc_name = "dev-vpc"
  cidr     = "10.0.0.0/16"

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

# EKS module
module "eks" {
  source          = "../modules/eks"
  cluster_name    = "dev-cluster-${random_string.suffix.result}"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}


# Addons
module "argo_cd" {
  source = "../modules/addons/argo-cd"
}
