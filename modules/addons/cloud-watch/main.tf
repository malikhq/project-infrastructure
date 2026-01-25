resource "aws_eks_addon" "cloudwatch" {
  cluster_name = var.cluster_name
  addon_name   = var.addon_name
}

