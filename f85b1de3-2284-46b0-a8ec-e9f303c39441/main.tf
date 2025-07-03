provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "success_bucket" {
  bucket = "test-morning-backend-issue-no-acl-success-try-12456"
  
  # ACLs are disabled by default in newer AWS provider versions
  # By not specifying any ACL, we ensure no ACL is applied
}

# Explicitly disable ACLs for the success bucket
resource "aws_s3_bucket_ownership_controls" "success_bucket_ownership" {
  bucket = aws_s3_bucket.success_bucket.id
  
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}