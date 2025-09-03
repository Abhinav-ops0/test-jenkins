terraform {
  backend "s3" {
    bucket = "opszero-2bd70404-8cf7-4900-96a3-66f5533acd7b"
    key    = "2bd70404-8cf7-4900-96a3-66f5533acd7b/836cf680-e2d5-42ac-8589-c8b41214526e/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}