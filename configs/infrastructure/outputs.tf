# Outputs for the infrastructure
# This file contains all output values from the Terraform configuration

output "bucket_name" {
  value       = aws_s3_bucket.test_repo_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.test_repo_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.test_repo_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.test_repo_bucket.bucket_regional_domain_name
  description = "The bucket region-specific domain name"
}