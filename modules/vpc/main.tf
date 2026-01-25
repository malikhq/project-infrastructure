data "aws_availability_zones" "available" {}
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.6.0"

  name = var.vpc_name
  cidr = var.cidr

  azs             = data.aws_availability_zones.available.names
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = {
    Managed_By  = "terraform-eks"
    Environment = "development"
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/dev-cluster" = "shared"
    "kubernetes.io/role/elb"            = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/dev-cluster" = "shared"
    "kubernetes.io/role/internal-elb"   = "1"
  }
}
