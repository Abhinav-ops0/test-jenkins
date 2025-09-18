# Configure AWS Provider (S3 is a global service, but we include region for DynamoDB table)
provider "aws" {
  region = "ap-south-1"  # Using the supported region
}

# Create S3 Bucket for state files
resource "aws_s3_bucket" "terraform_state" {
  bucket = "state-lock-check"

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name        = "state-lock-check"
    Environment = "production"
    Purpose     = "Terraform State Storage"
    Managed_by  = "Terraform"
    Created_at  = timestamp()
  }
}

# Enable versioning for state files
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
  bucket = aws_s3_bucket.terraform_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "terraform-state-lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-state-lock"
    Environment = "production"
    Purpose     = "Terraform State Locking"
    Managed_by  = "Terraform"
  }
}

# Output the bucket and DynamoDB table details
output "state_bucket_name" {
  value       = aws_s3_bucket.terraform_state.id
  description = "The name of the S3 bucket"
}

output "state_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_state_lock.name
  description = "The name of the DynamoDB table for state locking"
}