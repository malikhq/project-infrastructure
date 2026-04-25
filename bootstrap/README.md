<!-- BEGIN_TF_DOCS -->
# Main Terraform Configuration

This file serves as the entry point for provisioning the EKS cluster and its associated resources. It includes the VPC module for networking, the EKS module for cluster creation, and the Argo CD addon for GitOps deployment.

## Modules
- `vpc`: Provisions a Virtual Private Cloud with public and private subnets
- `eks`: Creates an EKS cluster with specified configurations and addons
- `argo_cd`: Deploys Argo CD using Helm for continuous delivery

## Usage
To deploy the infrastructure, run `terraform init` followed by `terraform apply` in the directory containing this configuration.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.0 |

## Usage
To use this module in your Terraform environment, include it in your Terraform configuration with the necessary parameters. Below is an example of how to use this module:

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_argo_cd"></a> [argo\_cd](#module\_argo\_cd) | ../modules/addons/argo-cd | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | ../modules/eks | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../modules/vpc | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [aws_eks_cluster_auth.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | backend bucket name | `string` | `"my-bucket"` | no |
| <a name="input_region"></a> [region](#input\_region) | aws region | `string` | `"us-east-1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The certificate authority data for the EKS cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for the EKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster |
| <a name="output_eks_connect"></a> [eks\_connect](#output\_eks\_connect) | EKS Connect configuration |
| <a name="output_vpc_name"></a> [vpc\_name](#output\_vpc\_name) | The name of the VPC |
<!-- END_TF_DOCS -->