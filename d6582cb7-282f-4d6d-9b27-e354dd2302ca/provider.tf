provider "aws" {
  region = var.region

  default_tags {
    tags = {
      "ManagedBy"   = "OpenTofu"
      "Project"     = var.project_name
      "Environment" = var.environment
    }
  }
}

