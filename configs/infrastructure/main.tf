# Configure AWS Provider (no region needed for S3 as it's a global service)
provider "aws" {}

# Create S3 Bucket
resource "aws_s3_bucket" "test_repo_bucket" {
  bucket = "test-new-repo-new-config-new-mod"

  tags = {
    Name        = "test-new-repo-new-config-new-mod"
    Environment = "test"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "test_repo_bucket_versioning" {
  bucket = aws_s3_bucket.test_repo_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test_repo_bucket_encryption" {
  bucket = aws_s3_bucket.test_repo_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "test_repo_bucket_public_access_block" {
  bucket = aws_s3_bucket.test_repo_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable access logging
resource "aws_s3_bucket_logging" "test_repo_bucket_logging" {
  bucket = aws_s3_bucket.test_repo_bucket.id

  target_bucket = aws_s3_bucket.test_repo_bucket.id
  target_prefix = "access-logs/"
}

# Add lifecycle rules for test environment
resource "aws_s3_bucket_lifecycle_configuration" "test_repo_bucket_lifecycle" {
  bucket = aws_s3_bucket.test_repo_bucket.id

  rule {
    id     = "test_environment_cleanup"
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

    # Clean up old versions after 30 days
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Output the bucket details