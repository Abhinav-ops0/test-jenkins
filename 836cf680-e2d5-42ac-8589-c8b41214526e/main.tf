provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "test-1243-test-24532-test"
}