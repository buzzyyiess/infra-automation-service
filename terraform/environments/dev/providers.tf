# Toolchain requirements and provider version pinning
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS provider declaration targeting the production region
provider "aws" {
  region = "ap-northeast-1"
}