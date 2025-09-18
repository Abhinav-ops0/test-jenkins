# Variables for the infrastructure
# This file contains all input variables for the Terraform configuration

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "test-with-modular-123"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "test"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Environment = "test"
    Managed_by  = "Terraform"
    Project     = "modular-test"
  }
}

# main.tf
# Create S3 Bucket