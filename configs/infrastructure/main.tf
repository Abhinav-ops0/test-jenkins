# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket with deletion protection
resource "aws_s3_bucket" "main" {
  bucket = "dont-destroy-last"

  # Enable force destroy to false for additional deletion protection
  force_destroy = false

  tags = {
    Name        = "dont-destroy-last"
    Environment = "Production"
    ManagedBy   = "Terraform"
    CreatedDate = timestamp()
    DoNotDelete = "true"
  }

  # Enable versioning by default
  versioning {
    enabled = true
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable MFA Delete for additional protection
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Enabled"
  }
}

# Add bucket policy to prevent deletion
resource "aws_s3_bucket_policy" "prevent_delete" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PreventDeleteBucket"
        Effect    = "Deny"
        Principal = "*"
        Action    = [
          "s3:DeleteBucket"
        ]
        Resource  = aws_s3_bucket.main.arn
        Condition = {
          StringNotLike = {
            "aws:PrincipalARN": ["arn:aws:iam::*:role/AdminRole"]  # Replace with your admin role ARN
          }
        }
      }
    ]
  })
}

# Enable lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_rule" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "protect_and_archive"
    status = "Enabled"

    # Move to IA after 30 days
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    # Move to Glacier after 90 days
    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    # Keep noncurrent versions
    noncurrent_version_transition {
      noncurrent_days = 30
      storage_class   = "GLACIER"
    }

    # Never expire current versions
    expiration {
      expired_object_delete_marker = true
    }
  }
}

# Output the bucket name and ARN
output "bucket_name" {
  value       = aws_s3_bucket.main.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.main.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.main.bucket_domain_name
  description = "The bucket domain name"
}