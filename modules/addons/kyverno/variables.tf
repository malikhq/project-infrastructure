variable "version" {
  description = "The version of Kyverno to install"
  type        = string
  default     = "3.7.1"
}

variable "namespace" {
  description = "The namespace where Kyverno will be installed"
  type        = string
  default     = "kyverno"
}