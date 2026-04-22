# Main Terraform configuration for bootstrapping the infrastructure
# This file defines the main resources and modules for setting up the VPC and EKS cluster.
# It also includes the random_string resource for generating a unique suffix for the cluster name.
# The modules for Argo CD and Kyverno are defined separately in their respective directories under modules/addons.

# Note: Ensure that the necessary providers and backend configurations are defined in the root module for Terraform to work correctly.    


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

module "kyverno" {
  source = "../modules/addons/kyverno"
}
