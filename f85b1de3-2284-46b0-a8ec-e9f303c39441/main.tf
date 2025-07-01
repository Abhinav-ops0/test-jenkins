provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "new_bucket" {
  bucket = var.new_bucket_name

  tags = {
    Name        = var.new_bucket_name
    Environment = var.environment
  }
}