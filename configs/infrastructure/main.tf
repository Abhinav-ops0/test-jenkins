# variables.tf
resource "aws_s3_bucket" "modular_bucket" {
  bucket = var.bucket_name

  tags = merge(var.tags, {
    Name       = var.bucket_name
    Created_at = timestamp()
  })
}

# Enable versioning
resource "aws_s3_bucket_versioning" "modular_bucket_versioning" {
  bucket = aws_s3_bucket.modular_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "modular_bucket_encryption" {
  bucket = aws_s3_bucket.modular_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access
resource "aws_s3_bucket_public_access_block" "modular_bucket_public_access_block" {
  bucket = aws_s3_bucket.modular_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Add lifecycle rules
resource "aws_s3_bucket_lifecycle_configuration" "modular_bucket_lifecycle" {
  bucket = aws_s3_bucket.modular_bucket.id

  rule {
    id     = "test_lifecycle"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 90
    }
  }
}

# outputs.tf