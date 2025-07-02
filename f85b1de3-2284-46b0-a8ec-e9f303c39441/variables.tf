variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-west-2"
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
  default     = "test-team-be-unique-eve"
}

variable "environment" {
  description = "Environment tag for the S3 bucket"
  type        = string
  default     = "dev"
}

variable "acl" {
  description = "ACL for the S3 bucket"
  type        = string
  default     = "private"
}