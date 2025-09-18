# Configure AWS Provider
# Note: Since S3 is a global service, we don't technically need a region,
# but including it for consistency with other AWS resources
provider "aws" {
}

# Create S3 Bucket
resource "aws_s3_bucket" "test_logic_bucket" {
  bucket = "test-new-logic-13442"

  tags = {
    Name        = "test-new-logic-13442"
    Environment = "test"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "test_logic_bucket_versioning" {
  bucket = aws_s3_bucket.test_logic_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "test_logic_bucket_encryption" {
  bucket = aws_s3_bucket.test_logic_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "test_logic_bucket_public_access_block" {
  bucket = aws_s3_bucket.test_logic_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rules for test environment
resource "aws_s3_bucket_lifecycle_configuration" "test_logic_bucket_lifecycle" {
  bucket = aws_s3_bucket.test_logic_bucket.id

  rule {
    id     = "test_cleanup"
    status = "Enabled"

    # Move files to cheaper storage after 30 days
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

# Output the bucket details