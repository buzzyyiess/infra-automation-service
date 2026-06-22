# Remote state configuration for the production environment
terraform {
  backend "s3" {
    bucket         = "tripla-global-tfstate"
    key            = "environments/prod/eks.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "tripla-tflocks" # Enables distributed state locking
  }
}