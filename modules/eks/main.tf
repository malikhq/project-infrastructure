locals {
  cluster_name = "${var.cluster_name}-${random_string.suffix.result}"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}


module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.15.0"
  name               = var.cluster_name
  kubernetes_version = "1.35"


  endpoint_public_access           = true
  enable_cluster_creator_admin_permissions  = false


  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # Enable KMS encryption for EKS secrets
  create_kms_key                = true
  kms_key_description           = "KMS Secrets encryption for EKS cluster."
  enable_irsa                   = true

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


