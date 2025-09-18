# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "test_config_bucket" {
  bucket = "s3-test-new-config-124242"

  tags = {
    Name        = "s3-test-new-config-124242"
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

# Enable access logging
resource "aws_s3_bucket_logging" "test_config_bucket_logging" {
  bucket = aws_s3_bucket.test_config_bucket.id

  target_bucket = aws_s3_bucket.test_config_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "test_config_bucket_lifecycle" {
  bucket = aws_s3_bucket.test_config_bucket.id

  rule {
    id     = "archive_and_delete"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
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

output "bucket_region" {
  value       = aws_s3_bucket.test_config_bucket.region
  description = "The region where the bucket is created"
}