provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "test-demo-purpose-34532"

  tags = {
    Name        = "test-demo-purpose-34532"
    Environment = var.environment
    Purpose     = "Demonstration"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "demo_bucket_ownership" {
  bucket = aws_s3_bucket.demo_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "demo_bucket_access" {
  bucket = aws_s3_bucket.demo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "demo_bucket_versioning" {
  bucket = aws_s3_bucket.demo_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}