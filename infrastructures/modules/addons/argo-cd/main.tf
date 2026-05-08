/** 
  * # Argo CD Helm Release
  *
  * This resource deploys Argo CD using the Helm provider. It specifies the chart version,
  * repository, and custom values for configuring Argo CD in the EKS cluster.
  *
  * ## Configuration
  * - `name`: The name of the Helm release (e.g., "argocd")
  * - `repository`: The Helm repository URL for Argo CD charts
  * - `chart`: The name of the chart to deploy (e.g., "argo-cd")
  * - `version`: The specific version of the chart to use (defined in variables)
  * - `namespace`: The Kubernetes namespace where Argo CD will be deployed
  * - `create_namespace`: Whether to create the namespace if it doesn't exist
  * - `values`: A list of YAML files containing custom values for the chart
  *
  * ## Usage
  * This resource is typically used in conjunction with an EKS cluster module to deploy Argo CD as part of a GitOps workflow.
  */

# Argo CD  resource 
resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version          = var.argocd_version
  namespace        = var.namespace
  create_namespace = true
  values = [
    file("${path.module}/values/argocd-values.yaml")
  ]
}