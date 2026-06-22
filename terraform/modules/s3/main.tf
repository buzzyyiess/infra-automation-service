resource "aws_s3_bucket" "static_assets" {
  bucket        = "${var.cluster_prefix}-static-assets-${var.environment}"
  force_destroy = var.environment == "dev" ? true : false

  tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Fixes modern AWS ACL restrictions
resource "aws_s3_bucket_ownership_controls" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_assets" {
  depends_on = [aws_s3_bucket_ownership_controls.static_assets]

  bucket = aws_s3_bucket.static_assets.id
  acl    = "public-read"
}

resource "aws_s3_bucket_versioning" "static_assets" {
  bucket = aws_s3_bucket.static_assets.id
  versioning_configuration {
    status = "Enabled"
  }
}

output "bucket_name" {
  value = aws_s3_bucket.static_assets.id
}