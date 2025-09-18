# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "test_config_bucket" {
  bucket = "test-1232-config-test-test-test"

  tags = {
    Name        = "test-1232-config-test-test-test"
    Environment = "test"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "test_config_bucket_versioning" {
  bucket = aws_s3_bucket.test_config_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test_config_bucket_encryption" {
  bucket = aws_s3_bucket.test_config_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "test_config_bucket_public_access_block" {
  bucket = aws_s3_bucket.test_config_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rules for test environment
resource "aws_s3_bucket_lifecycle_configuration" "test_config_bucket_lifecycle" {
  bucket = aws_s3_bucket.test_config_bucket.id

  rule {
    id     = "test_environment_cleanup"
    status = "Enabled"

    # Transition to IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Clean up old versions after 60 days
    noncurrent_version_expiration {
      noncurrent_days = 60
    }

    # Delete markers for expired objects
    expiration {
      expired_object_delete_marker = true
    }
  }
}

# Output the bucket details
output "bucket_name" {
  value       = aws_s3_bucket.test_config_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.test_config_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.test_config_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.test_config_bucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name"
}