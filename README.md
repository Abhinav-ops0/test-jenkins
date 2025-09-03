# S3 Bucket Demo Configuration

This Terraform configuration creates an AWS S3 bucket for demonstration purposes.

## Resources Created

- AWS S3 Bucket named "test-demo-purpose-34532"
- S3 Bucket Ownership Controls
- S3 Bucket Public Access Block (all public access blocked)
- S3 Bucket Versioning (enabled)

## Usage

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply changes
terraform apply

# Destroy resources when no longer needed
terraform destroy
```

## Variables

- `aws_region`: AWS region where the S3 bucket will be created (default: us-west-2)
- `environment`: Environment name for tagging (default: dev)