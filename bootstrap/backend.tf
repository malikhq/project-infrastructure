terraform {
  backend "s3" {
    bucket       = "malikhq-dev-infra-tfstate"
    key          = "dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}