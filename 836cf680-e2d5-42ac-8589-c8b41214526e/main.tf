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