# Continuous Integration (CI)

This document describes the repository's CI workflows and current GitHub Actions configuration.

## CI workflows

The main CI workflows are defined in `.github/workflows/`:

- `.github/workflows/create_infra.yaml` — Terraform CI for plan validation and pull request previews
- `.github/workflows/tflint.yaml` — Terraform lint checks
- `.github/workflows/terraform-doc.yaml` — Terraform docs generation for module READMEs

## Terraform CI

The `create_infra.yaml` workflow is the primary CI pipeline for Terraform.

### Triggering events

- `push` to `main`
- `pull_request`

### Workflow steps

- Checkout the repository
- Configure AWS credentials using GitHub OIDC
- Run `terraform fmt -check`
- Run `terraform init -upgrade` in `./infrastructures/bootstrap`
- Run `terraform plan` on pull requests via `op5dev/tf-via-pr`
- `terraform apply` is currently commented out for safety

### AWS authentication

The workflow assumes the role:

- `arn:aws:iam::564121863674:role/terraform-oidc-role`

It uses GitHub Actions `aws-actions/configure-aws-credentials` with `aws-region: us-east-1`.

### Plan execution

On pull requests, the workflow uses `op5dev/tf-via-pr` to produce an encrypted Terraform plan.
The plan is encrypted using the repository secret `PASSPHRASE`.

### Terraform working directory

The workflow sets:

```yaml
env:
  TF_WORKING_DIR: ./infrastructures/bootstrap
```

Update this path if the Terraform root directory changes.

## Linting and documentation workflows

### TFLint

The workflow in `.github/workflows/tflint.yaml` validates Terraform HCL style and provider best practices.

### Terraform Docs

The workflow in `.github/workflows/terraform-doc.yaml` regenerates module Markdown documentation from Terraform source metadata.

## Notes

- The CI documentation will expand as GitOps, Helm, monitoring, and security workflows are added.
- The current documentation set includes only infrastructure and CI guidance.