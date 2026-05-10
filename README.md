# Platform Engineering Lab

This repository contains the platform engineering lab setup for a cloud-native development environment.
It includes Terraform infrastructure, application scaffolding, GitOps patterns, Helm definitions, monitoring, and security configuration.

The source of documentation is located in the `documentations/` directory.

## Project Structure

```text
.
|-- ai-workflows/       # Reserved for AI workflow automation and experiments
|-- apps/               # Reserved for application workloads and service manifests
|-- documentations      # Reserved for documentation
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

## Documentation

- [Infrastructure](documentations/infrastructure.md) - Terraform setup for AWS EKS platform
- [Continuous Integration (CI)](documentations/ci.md) - GitHub Actions workflows for Terraform, linting, and docs generation
- GitOps - Coming soon
- Helm - Coming soon
- Monitoring - Coming soon
- Security - Coming soon
