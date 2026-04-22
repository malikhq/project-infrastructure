# Terraform EKS Infrastructure

This repository contains **Terraform-based infrastructure code** to deploy and manage a **modular AWS EKS (Elastic Kubernetes Service) cluster**. It includes VPC setup, cluster bootstrapping, and common add-ons like ArgoCD.

---

## Table of Contents

- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
- [Modules](#modules)
- [Scripts](#scripts)
- [Best Practices](#best-practices)
---

## Project Structure

```

.
├── README.md
├── bootstrap       # Terraform bootstrap for EKS cluster
├── modules         # Reusable Terraform modules
│   ├── addons      # Add-ons like ArgoCD, CloudWatch, Helm, Kyverno
│   ├── eks         # EKS cluster module
│   └── vpc         # VPC networking module
                 

````

---

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.5
- [AWS CLI](https://aws.amazon.com/cli/) configured with proper credentials
- AWS account with permissions for VPC, EKS, IAM, and related resources
- kubectl installed for managing the EKS cluster
- Helm (if deploying Helm-based add-ons)

---

## Usage

1. **Initialize Terraform**

```bash
cd bootstrap
terraform init
````

2. **Plan the deployment**

```bash
terraform plan
```

3. **Apply the infrastructure**

```bash
terraform apply
```

4. **Destroy the infrastructure** (if needed)

```bash
terraform destroy
```

---

## Modules

### VPC

Provides networking components: VPC, subnets, route tables, and security groups.

### EKS

Deploys the EKS cluster with configurable node groups, Fargate profiles, and IAM roles.

### Add-ons

Optional modules to install and configure common tools:

* **ArgoCD**: GitOps deployment
* **Helm**: Helm package management
---

## Best Practices

* Keep `.terraform` directories and Terraform state files out of Git
* Use `.gitignore` to ignore `.terraform` and `.terraform.lock.hcl`
* Use separate Terraform workspaces for environments (dev/staging/prod)
* Enable cluster logging and monitoring for better observability
* Use IAM roles and policies with least privilege

---



💡 Tips:  
- You can expand each add-on module section with **usage examples** later.  
- You can also link to **scripts usage** if they are complex.  

