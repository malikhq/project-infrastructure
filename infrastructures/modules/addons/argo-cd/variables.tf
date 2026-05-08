variable "argocd_version" {
  description = "The version of Argo CD to install"
  type        = string
  default     = "4.5.2"
}

variable "namespace" {
  description = "The namespace where Argo CD will be installed"
  type        = string
  default     = "argocd"
}