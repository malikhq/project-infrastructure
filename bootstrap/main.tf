
resource "random_string" "suffix" {
  length  = 8
  special = false
}

module "vpc" {
  source   = "../modules/vpc"
  vpc_name = "dev-vpc"
  cidr     = "10.0.0.0/16"

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}


module "eks" {
  source          = "../modules/eks"
  cluster_name    = "dev-cluster-${random_string.suffix.result}"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}


# module "cloudwatch" {
#   source       = "../modules/addons/cloud-watch"
#   cluster_name = module.eks.cluster_name
#   addon_name   = "dev-cloudwatch-observability"
# }



