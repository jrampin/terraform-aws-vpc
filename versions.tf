terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43.0"
    }
  }

  # Terraform Version
  required_version = "~> 1.0.0"
}
