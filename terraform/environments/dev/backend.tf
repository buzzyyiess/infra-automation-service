# Remote state configuration for the development environment
terraform {
  backend "s3" {
    bucket         = "tripla-global-tfstate"
    key            = "environments/dev/eks.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tripla-tflocks" # Enables distributed state locking
  }
}