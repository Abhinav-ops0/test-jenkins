provider "aws" {
  region = "us-east-1"  # You can change this to your preferred region
}

resource "aws_s3_bucket" "test_demo_bucket" {
  bucket = "test-demo-purpose-34532"
  
  tags = {
    Name        = "test-demo-purpose-34532"
    Environment = "test"
    Purpose     = "demo"
  }
}

# S3 bucket ACL
resource "aws_s3_bucket_ownership_controls" "test_demo_bucket_ownership" {
  bucket = aws_s3_bucket.test_demo_bucket.id
  
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "test_demo_bucket_access" {
  bucket = aws_s3_bucket.test_demo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for the bucket
resource "aws_s3_bucket_versioning" "test_demo_bucket_versioning" {
  bucket = aws_s3_bucket.test_demo_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}