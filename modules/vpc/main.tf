/**
 * # VPC Module
 *
 * This module creates a Virtual Private Cloud (VPC) with public and private subnets, along with a NAT gateway for internet access from the private subnets. It uses the `terraform-aws-modules/vpc/aws` module to provision the necessary networking resources for the EKS cluster.
 *
 * ## Configuration
 * - `name`: The name of the VPC (e.g., "my-vpc")
 * - `cidr`: The CIDR block for the VPC (e.g., "10.0.0.0/16")
 * ## Usage
 * This module can be used in a Terraform configuration to create a VPC with the specified settings.
 */


# This module creates a VPC with public and private subnets, and a NAT gateway for internet access from the private subnets.
data "aws_availability_zones" "available" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}


module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 6.6.0"

  name = var.vpc_name
  cidr = var.cidr

  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  tags = {

  }
  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }
}
