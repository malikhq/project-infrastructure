# Kyverno  resource 
resource "helm_release" "kyverno" {
  name       = "kyverno"
  repository = "https://kyverno.github.io/charts"
  chart      = "kyverno"
  version    = var.version
  namespace = var.namespace
  create_namespace = true
  values = [
    file("${path.module}/files/kyverno-values.yaml")
  ]
}
