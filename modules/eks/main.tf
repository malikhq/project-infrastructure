/**
 * # EKS Cluster Module
 * This module uses the `terraform-aws-modules/eks/aws` module to create an EKS cluster with specified configurations. It includes settings for Kubernetes version, node groups, logging, and addons.               
 * ## Configuration
 * - `name`: The name of the EKS cluster (e.g., "my-eks-cluster")
 * - `kubernetes_version`: The version of Kubernetes to use (e.g., "1.35")
 * - `vpc_id`: The ID of the VPC where the cluster will be deployed
 * - `subnet_ids`: A list of subnet IDs for the cluster nodes
 * - `addons`: A map of addons to install (e.g., CoreDNS, VPC CNI)
 * - `encryption_config`: Configuration for encrypting Kubernetes secrets using KMS
 * - `enabled_log_types`: A list of control plane log types to enable (e.g., "api", "audit")
 * - `cloudwatch_log_group_retention_in_days`: Retention period for CloudWatch logs
 * - `eks_managed_node_groups`: Configuration for EKS managed node groups, including instance types and scaling settings
 * - `tags`: A map of tags to apply to the cluster resources
 * ## Usage
 * This module can be used in a Terraform configuration to create an EKS cluster with the specified settings. It can be combined with other modules (e.g., for addons like Argo CD) to deploy a complete Kubernetes environment.
 */


module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.15.0"
  name               = var.cluster_name
  kubernetes_version = "1.35"


  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true


  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # Enable KMS encryption for EKS secrets
  create_kms_key      = true
  kms_key_description = "KMS Secrets encryption for EKS cluster."
  enable_irsa         = true

  # EKS Addons
  addons = {
    coredns = {}
    aws-ebs-csi-driver = {
      service_account_role_arn = module.ebs_csi_driver_irsa.arn
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  encryption_config = {
    resources = ["secrets"]
  }

  # enable control plane logging
  enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]
  cloudwatch_log_group_retention_in_days = 30

  # EKS Managed Node Group
  eks_managed_node_groups = {
    dev = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 2
      desired_size = 2
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}


# IRSA IAM Role for Service Accounts
# ebs-csi-controller-sa is the default service account name for the EBS CSI driver controller component

module "ebs_csi_driver_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version = "~> 5.0"

  name = "ebs-csi"

  attach_ebs_csi_policy = true

  oidc_providers = {
    this = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


