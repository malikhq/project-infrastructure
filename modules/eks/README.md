<!-- BEGIN_TF_DOCS -->
# EKS Cluster Module
This module uses the `terraform-aws-modules/eks/aws` module to create an EKS cluster with specified configurations. It includes settings for Kubernetes version, node groups, logging, and addons.               
## Configuration
- `name`: The name of the EKS cluster (e.g., "my-eks-cluster")
- `kubernetes_version`: The version of Kubernetes to use (e.g., "1.35")
- `vpc_id`: The ID of the VPC where the cluster will be deployed
- `subnet_ids`: A list of subnet IDs for the cluster nodes
- `addons`: A map of addons to install (e.g., CoreDNS, VPC CNI)
- `encryption_config`: Configuration for encrypting Kubernetes secrets using KMS
- `enabled_log_types`: A list of control plane log types to enable (e.g., "api", "audit")
- `cloudwatch_log_group_retention_in_days`: Retention period for CloudWatch logs
- `eks_managed_node_groups`: Configuration for EKS managed node groups, including instance types and scaling settings
- `tags`: A map of tags to apply to the cluster resources
## Usage
This module can be used in a Terraform configuration to create an EKS cluster with the specified settings. It can be combined with other modules (e.g., for addons like Argo CD) to deploy a complete Kubernetes environment.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Usage
To use this module in your Terraform environment, include it in your Terraform configuration with the necessary parameters. Below is an example of how to use this module:

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ebs_csi_driver_irsa"></a> [ebs\_csi\_driver\_irsa](#module\_ebs\_csi\_driver\_irsa) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | n/a |
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> 21.15.0 |

## Resources

| Name | Type |
|------|------|
| [random_string.suffix](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the EKS cluster | `string` | `"dev-eks-cluster"` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | The private subnets for the EKS cluster | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the EKS cluster will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | The certificate authority data for the EKS cluster |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | The endpoint for the EKS cluster |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the EKS cluster |
<!-- END_TF_DOCS -->