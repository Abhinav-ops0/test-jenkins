# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket with versioning and encryption
resource "aws_s3_bucket" "new_logs_bucket" {
  bucket = "new-love-logs"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "new-love-logs"
    Environment = "production"
    Purpose     = "Logging"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "new_logs_bucket_versioning" {
  bucket = aws_s3_bucket.new_logs_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "new_logs_bucket_encryption" {
  bucket = aws_s3_bucket.new_logs_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "new_logs_bucket_public_access_block" {
  bucket = aws_s3_bucket.new_logs_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "new_logs_bucket_logging" {
  bucket = aws_s3_bucket.new_logs_bucket.id

  target_bucket = aws_s3_bucket.new_logs_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rule to move old logs to cheaper storage
resource "aws_s3_bucket_lifecycle_configuration" "new_logs_bucket_lifecycle" {
  bucket = aws_s3_bucket.new_logs_bucket.id

  rule {
    id     = "archive_old_logs"
    status = "Enabled"

    transition {
      days          = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 180
      storage_class = "GLACIER"
    }

    expiration {
      days = 365
    }
  }
}

# Output the bucket name and ARN
output "bucket_name" {
  value       = aws_s3_bucket.new_logs_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.new_logs_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_region" {
  value       = aws_s3_bucket.new_logs_bucket.region
  description = "The region where the bucket is created"
}