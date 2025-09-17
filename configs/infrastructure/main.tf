# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "test1234"

  tags = {
    Name        = "test1234"
    Environment = "test"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "test_bucket_versioning" {
  bucket = aws_s3_bucket.test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test_bucket_encryption" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "test_bucket_public_access_block" {
  bucket = aws_s3_bucket.test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rule for test environment
resource "aws_s3_bucket_lifecycle_configuration" "test_bucket_lifecycle" {
  bucket = aws_s3_bucket.test_bucket.id

  rule {
    id     = "cleanup_test_files"
    status = "Enabled"

    # Move files to Standard-IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Delete files after 90 days
    expiration {
      days = 90
    }
  }
}

# Output the bucket details
output "bucket_name" {
  value       = aws_s3_bucket.test_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.test_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_region" {
  value       = aws_s3_bucket.test_bucket.region
  description = "The region where the bucket is created"
}