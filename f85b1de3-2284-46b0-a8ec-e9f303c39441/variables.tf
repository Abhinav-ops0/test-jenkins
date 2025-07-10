variable "aws_region" {
  description = "AWS region for the S3 bucket"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment for the S3 bucket (e.g., dev, prod)"
  type        = string
  default     = "dev"
}