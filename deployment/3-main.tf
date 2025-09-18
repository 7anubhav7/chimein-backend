terraform {
  backend "s3" {
    bucket  = "chimein-app-terraform-state"
    region  = "ap-south-1"
    encrypt = true
  }
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    ManagedBy   = "Terraform"
    Owner       = "Anubhav Hajela"
  }
}
