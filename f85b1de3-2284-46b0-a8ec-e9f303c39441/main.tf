provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "test-morning-backend-issue-no-acl"
  
  # ACLs are disabled by default in newer AWS provider versions
  # By not specifying any ACL, we ensure no ACL is applied
}

# Explicitly disable ACLs for the bucket
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.bucket.id
  
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket" "new_bucket" {
  bucket = "test-morning-backend-issue-no-acl-1"
  
  # ACLs are disabled by default in newer AWS provider versions
  # By not specifying any ACL, we ensure no ACL is applied
}

# Explicitly disable ACLs for the new bucket
resource "aws_s3_bucket_ownership_controls" "new_bucket_ownership" {
  bucket = aws_s3_bucket.new_bucket.id
  
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket" "success_bucket" {
  bucket = "test-morning-backend-issue-no-acl-success-try"
  
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