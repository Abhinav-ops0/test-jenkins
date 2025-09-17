# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-3"

  tags = {
    Name        = "test-3"
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
    id     = "test_environment_cleanup"
    status = "Enabled"

    expiration {
      days = 30  # Delete objects after 30 days in test environment
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
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

output "bucket_domain_name" {
  value       = aws_s3_bucket.test_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_region" {
  value       = aws_s3_bucket.test_bucket.region
  description = "The region where the bucket is created"
}