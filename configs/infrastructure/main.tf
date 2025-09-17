# Configure AWS Provider
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "robust_test_bucket" {
  bucket = "test-4-robust"

  tags = {
    Name        = "test-4-robust"
    Environment = "test"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "robust_test_bucket_versioning" {
  bucket = aws_s3_bucket.robust_test_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "robust_test_bucket_encryption" {
  bucket = aws_s3_bucket.robust_test_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "robust_test_bucket_public_access_block" {
  bucket = aws_s3_bucket.robust_test_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "robust_test_bucket_logging" {
  bucket = aws_s3_bucket.robust_test_bucket.id

  target_bucket = aws_s3_bucket.robust_test_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules for test environment
resource "aws_s3_bucket_lifecycle_configuration" "robust_test_bucket_lifecycle" {
  bucket = aws_s3_bucket.robust_test_bucket.id

  rule {
    id     = "test_environment_cleanup"
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

    # Clean up incomplete multipart uploads
    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }
}

# Add bucket policy to enforce SSL
resource "aws_s3_bucket_policy" "robust_test_bucket_policy" {
  bucket = aws_s3_bucket.robust_test_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "ForceSSLOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.robust_test_bucket.arn,
          "${aws_s3_bucket.robust_test_bucket.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      }
    ]
  })
}

# Output the bucket details
output "bucket_name" {
  value       = aws_s3_bucket.robust_test_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.robust_test_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.robust_test_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.robust_test_bucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name"
}