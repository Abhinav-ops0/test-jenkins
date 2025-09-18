# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "bulk_refresh_bucket" {
  bucket = "test-bulk-refresh"

  tags = {
    Name        = "test-bulk-refresh"
    Environment = "test"
    Purpose     = "Bulk Operations Testing"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "bulk_refresh_bucket_versioning" {
  bucket = aws_s3_bucket.bulk_refresh_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bulk_refresh_bucket_encryption" {
  bucket = aws_s3_bucket.bulk_refresh_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "bulk_refresh_bucket_public_access_block" {
  bucket = aws_s3_bucket.bulk_refresh_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rules for test environment
resource "aws_s3_bucket_lifecycle_configuration" "bulk_refresh_bucket_lifecycle" {
  bucket = aws_s3_bucket.bulk_refresh_bucket.id

  rule {
    id     = "test_cleanup"
    status = "Enabled"

    # Move files to IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Delete files after 90 days
    expiration {
      days = 90
    }

    # Clean up old versions after 30 days
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Enable access logging
resource "aws_s3_bucket_logging" "bulk_refresh_bucket_logging" {
  bucket = aws_s3_bucket.bulk_refresh_bucket.id

  target_bucket = aws_s3_bucket.bulk_refresh_bucket.id
  target_prefix = "access-logs/"
}

# Output the bucket details
output "bucket_name" {
  value       = aws_s3_bucket.bulk_refresh_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.bulk_refresh_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.bulk_refresh_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.bulk_refresh_bucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name"
}