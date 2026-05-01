variable "region" {
  description = "aws region"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "backend bucket name"
  type        = string
  default     = "malikhq-dev-infra-tfstate"

}