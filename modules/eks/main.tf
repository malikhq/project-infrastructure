module "eks" {
  source             = "terraform-aws-modules/eks/aws"
  version            = "~> 21.0.0"
  name               = var.cluster_name
  kubernetes_version = "1.35"


  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }
  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # Enable KMS encryption for EKS secrets
  create_kms_key                = true
  kms_key_description           = "KMS Secrets encryption for EKS cluster."
  kms_key_enable_default_policy = true
  enable_irsa                   = true

  encryption_config = {
    resources = ["secrets"]
  }

  node_security_group_additional_rules = {
    ingress_cluster_api = {
      description = "Allow cluster API"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      type        = "ingress"
      source_cluster_security_group = true
    }
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

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    dev = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t2.micro"]

      min_size     = 1
      max_size     = 2
      desired_size = 2

      # Additional IAM policies for the node group IAM role
      iam_role_additional_policies = {
        ebs = "arn:aws:iam::aws:policy/AmazonEBSCSIDriverPolicy"
        ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  tags = {
    Environment = "dev"
    ManagedBy   = "terraform"
  }
}





# IRSA IAM Role for Service Accounts
