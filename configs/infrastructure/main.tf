# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create S3 bucket
resource "aws_s3_bucket" "help_me1334" {
  bucket = "help-me1334"

  tags = {
    Name        = "help-me1334"
    Environment = "dev"
    Managed_by  = "terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.help_me1334.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.help_me1334.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.help_me1334.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Output the bucket name and ARN
output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.help_me1334.id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = aws_s3_bucket.help_me1334.arn
}