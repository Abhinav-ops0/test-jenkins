# Outputs for the infrastructure
# This file contains all output values from the Terraform configuration

output "bucket_name" {
  value       = aws_s3_bucket.modular_bucket.id
  description = "The name of the bucket"
}

output "bucket_arn" {
  value       = aws_s3_bucket.modular_bucket.arn
  description = "The ARN of the bucket"
}

output "bucket_domain_name" {
  value       = aws_s3_bucket.modular_bucket.bucket_domain_name
  description = "The bucket domain name"
}

output "bucket_region" {
  value       = aws_s3_bucket.modular_bucket.region
  description = "The AWS region where the bucket is located"
}