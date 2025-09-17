# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "test_rest_bucket" {
  bucket = "test-rest-1242424"

  tags = {
    Name        = "test-rest-1242424"
    Environment = "test"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "test_rest_bucket_versioning" {
  bucket = aws_s3_bucket.test_rest_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test_rest_bucket_encryption" {
  bucket = aws_s3_bucket.test_rest_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "test_rest_bucket_public_access_block" {
  bucket = aws_s3_bucket.test_rest_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rules for test environment
resource "aws_s3_bucket_lifecycle_configuration" "test_rest_bucket_lifecycle" {
  bucket = aws_s3_bucket.test_rest_bucket.id

  rule {
    id     = "test_cleanup"
    status = "Enabled"

    # Clean up old files after 30 days in test environment
    expiration {
      days = 30
    }

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Output the bucket details
output "bucket_name" {
  value       = aws_s3_bucket.test_rest_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.test_rest_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.test_rest_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.test_rest_bucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name"
}