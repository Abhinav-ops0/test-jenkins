variable "aws_region" {
  description = "AWS region where the S3 bucket will be created"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "environment" {
  description = "Environment (e.g. dev, staging, prod)"
  type        = string
  default     = "dev"
}