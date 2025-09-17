# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 Bucket
resource "aws_s3_bucket" "socket_io_bucket" {
  bucket = "test-socket-io"

  tags = {
    Name        = "test-socket-io"
    Environment = "test"
    Purpose     = "Socket.IO Testing"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "socket_io_bucket_versioning" {
  bucket = aws_s3_bucket.socket_io_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "socket_io_bucket_encryption" {
  bucket = aws_s3_bucket.socket_io_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "socket_io_bucket_public_access_block" {
  bucket = aws_s3_bucket.socket_io_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable CORS for Socket.IO
resource "aws_s3_bucket_cors_configuration" "socket_io_bucket_cors" {
  bucket = aws_s3_bucket.socket_io_bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
    allowed_origins = ["*"]  # Consider restricting this to specific domains in production
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# Add lifecycle rule for test environment
resource "aws_s3_bucket_lifecycle_configuration" "socket_io_bucket_lifecycle" {
  bucket = aws_s3_bucket.socket_io_bucket.id

  rule {
    id     = "cleanup_old_files"
    status = "Enabled"

    expiration {
      days = 30  # Delete files after 30 days in test environment
    }
  }
}

# Output the bucket name and ARN
output "bucket_name" {
  value       = aws_s3_bucket.socket_io_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.socket_io_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.socket_io_bucket.bucket_domain_name
  description = "The bucket domain name"
}