# Terraform EKS Platform Lab

This repository provisions a development AWS EKS platform with Terraform. The root stack lives in `infrastructures/bootstrap` and composes reusable modules for networking, EKS, and platform add-ons.

The current stack creates:

- A VPC across three availability zones
- Public and private subnets with Kubernetes load balancer tags
- A single NAT gateway for private subnet egress
- An EKS cluster with managed node groups
- EKS control plane logging
- KMS encryption for Kubernetes secrets
- IRSA support
- Core EKS add-ons: CoreDNS, kube-proxy, VPC CNI, and AWS EBS CSI driver
- Argo CD installed through Helm

## Project Structure

```text
.
|-- ai-workflows/       # Reserved for AI workflow automation and experiments
|-- apps/               # Reserved for application workloads and service manifests
|-- documentations      # Reserved for documentations 
|-- gitops/             # Reserved for GitOps application definitions
|-- helm/               # Reserved for reusable Helm charts or values
|-- infrastructures/
|   |-- bootstrap/
|   |   |-- backend.tf       # Remote state backend configuration
|   |   |-- main.tf          # Root composition for VPC, EKS, and add-ons
|   |   |-- outputs.tf       # Useful connection and cluster outputs
|   |   |-- providers.tf     # AWS, Kubernetes, Helm, and Random providers
|   |   `-- variables.tf     # Root input variables
|   `-- modules/
|       |-- addons/
|       |   `-- argo-cd/     # Argo CD Helm release module
|       |-- eks/             # EKS cluster module
|       `-- vpc/             # VPC networking module
|-- monitoring/         # Reserved for observability configuration
|-- security/           # Reserved for security policies, scans, and controls
|-- .github/workflows/
|   |-- create_infra.yaml    # Terraform plan workflow
|   |-- terraform-doc.yaml   # Module README generation workflow
|   `-- tflint.yaml          # Terraform lint workflow
`-- .terraform-docs.yml      # terraform-docs configuration
```

The top-level `ai-workflows`, `apps`, `gitops`, `helm`, `monitoring`, and `security` directories are currently placeholders. They are included to show the intended platform layout as the lab grows beyond the base Terraform infrastructure.

## Prerequisites

- Terraform `~> 1.5`
- AWS CLI configured for the target account
- An AWS identity with permissions for VPC, EKS, IAM, KMS, CloudWatch Logs, S3 state, and related resources
- `kubectl` for cluster access after provisioning
- Helm provider access through Terraform for add-on installation
- An existing S3 backend bucket named `malikhq-dev-infra-tfstate`

## Remote State

Terraform state is configured in [infrastructures/bootstrap/backend.tf](infrastructures/bootstrap/backend.tf):

```hcl
bucket       = "malikhq-dev-infra-tfstate"
key          = "dev/terraform.tfstate"
region       = "us-east-1"
use_lockfile = true
```

Create or confirm this backend before running `terraform init`. The backend stores the development state file at `dev/terraform.tfstate`.

## Usage

Run Terraform from the bootstrap directory:

```bash
cd infrastructures/bootstrap
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

To destroy the development stack:

```bash
cd infrastructures/bootstrap
terraform destroy
```

## Configuration

The root configuration currently defaults to `us-east-1`:

| Variable | Default | Description |
| --- | --- | --- |
| `region` | `us-east-1` | AWS region used by the root providers |

The bootstrap stack currently hard-codes the development network and cluster shape in [infrastructures/bootstrap/main.tf](infrastructures/bootstrap/main.tf):

| Setting | Value |
| --- | --- |
| VPC name | `dev-vpc` |
| VPC CIDR | `10.0.0.0/16` |
| Private subnets | `10.0.1.0/24`, `10.0.2.0/24`, `10.0.3.0/24` |
| Public subnets | `10.0.4.0/24`, `10.0.5.0/24`, `10.0.6.0/24` |
| Cluster name | `dev-cluster-${random_string.suffix.result}` |
| Argo CD namespace | `argocd` |

## Modules

### VPC

Path: [infrastructures/modules/vpc](infrastructures/modules/vpc)

This module wraps `terraform-aws-modules/vpc/aws` version `~> 6.6.0`.

It creates:

- VPC
- Three private subnets
- Three public subnets
- One NAT gateway
- DNS hostnames
- Kubernetes public subnet tag: `kubernetes.io/role/elb`
- Kubernetes private subnet tag: `kubernetes.io/role/internal-elb`

### EKS

Path: [infrastructures/modules/eks](infrastructures/modules/eks)

This module wraps `terraform-aws-modules/eks/aws` version `~> 21.15.0`.

It creates:

- Kubernetes version `1.35`
- Public EKS API endpoint
- Cluster creator admin permissions
- KMS key for EKS secret encryption
- IRSA/OIDC support
- Control plane logs: `api`, `audit`, `authenticator`, `controllerManager`, `scheduler`
- 30-day CloudWatch log retention
- Managed node group named `dev`
- `t3.small` worker nodes with `min_size = 1`, `desired_size = 2`, and `max_size = 2`
- EBS CSI driver IAM role through `terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks`

### Argo CD

Path: [infrastructures/modules/addons/argo-cd](infrastructures/modules/addons/argo-cd)

This module installs Argo CD with the Helm provider.

Current defaults:

| Variable | Default | Description |
| --- | --- | --- |
| `argocd_version` | `4.5.2` | Argo CD Helm chart version |
| `namespace` | `argocd` | Kubernetes namespace created for Argo CD |

The Helm values file is stored at [infrastructures/modules/addons/argo-cd/values/argocd-values.yaml](infrastructures/modules/addons/argo-cd/values/argocd-values.yaml).

## Outputs

After apply, the root stack exposes:

| Output | Description |
| --- | --- |
| `vpc_name` | Name of the created VPC |
| `cluster_name` | Name of the EKS cluster |
| `cluster_endpoint` | EKS API endpoint |
| `eks_connect` | Ready-to-run `aws eks update-kubeconfig` command |
| `cluster_certificate_authority_data` | Cluster certificate authority data, marked sensitive |

To configure local `kubectl` access:

```bash
cd infrastructures/bootstrap
terraform output -raw eks_connect
```

Run the command returned by that output, then verify access:

```bash
kubectl get nodes
kubectl get pods -n argocd
```

## CI Workflows

### Terraform CI

[.github/workflows/create_infra.yaml](.github/workflows/create_infra.yaml) runs Terraform from `./infrastructures/bootstrap`.

- Pull requests run `terraform init` and `terraform plan`
- Pushes to `main` currently run the workflow, but the `terraform apply` step is commented out
- AWS authentication uses GitHub OIDC and assumes `arn:aws:iam::564121863674:role/terraform-oidc-role`
- Plans are handled through `op5dev/tf-via-pr`
- The workflow expects `secrets.PASSPHRASE` for encrypted plan handling

### TFLint

[.github/workflows/tflint.yaml](.github/workflows/tflint.yaml) runs on pull requests and uses TFLint `v0.52.0`.

### Terraform Docs

[.github/workflows/terraform-doc.yaml](.github/workflows/terraform-doc.yaml) regenerates module README files on pull requests using [.terraform-docs.yml](.terraform-docs.yml).

The recursive terraform-docs configuration targets modules under `infrastructures/modules`. Module READMEs are generated documentation, so durable module documentation changes should be made in Terraform headers, variables, outputs, and `.terraform-docs.yml`.

## Operational Notes

- Keep `.terraform/`, `*.tfstate`, and local plan files out of Git.
- Commit `.terraform.lock.hcl` for reproducible provider selections unless there is a deliberate reason not to.
- Treat the current bootstrap values as a development environment baseline.
- Review Kubernetes and EKS version compatibility before changing `kubernetes_version`.
- The VPC module currently uses one NAT gateway. This is cost-conscious for development, but less resilient than one NAT gateway per AZ.
- The EKS API endpoint is public. Restrict access before using this for sensitive environments.
- Argo CD is installed after the cluster providers are configured from the EKS module outputs.
