terraform {
  backend "s3" {
    bucket = "opszero-2bd70404-8cf7-4900-96a3-66f5533acd7b"
    key    = "2bd70404-8cf7-4900-96a3-66f5533acd7b/98854906-ce43-40aa-9725-f012617e8ba6/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}