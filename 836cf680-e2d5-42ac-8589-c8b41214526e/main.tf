provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "db_bucket" {
  bucket = "teset-db-1234323"

  tags = {
    Name        = "teset-db-1234323"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "demo_bucket" {
  bucket = "test-123-demo-purpose-123"

  tags = {
    Name        = "test-123-demo-purpose-123"
    Environment = var.environment
    Purpose     = "Demo"
  }
}