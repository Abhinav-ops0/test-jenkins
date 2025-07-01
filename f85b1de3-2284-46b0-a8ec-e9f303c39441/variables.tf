variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "new_bucket_name" {
  description = "The name of the new S3 bucket"
  type        = string
}

variable "environment" {
  description = "The environment (e.g., dev, prod, staging)"
  type        = string
  default     = "dev"
}