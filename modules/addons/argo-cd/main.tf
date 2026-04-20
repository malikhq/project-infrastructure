# Argo CD  resource 
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.version
  namespace = var.namespace
  create_namespace = true
  values = [
    file("${path.module}/files/argocd-values.yaml")
  ]
}
