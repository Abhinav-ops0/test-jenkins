# S3 Bucket Demo Configuration

This directory contains Terraform configuration for creating an AWS S3 bucket named `test-demo-purpose-34532`.

## Resources Created

- S3 Bucket with the name "test-demo-purpose-34532"
- Bucket ownership controls
- Public access block settings (all public access blocked)
- Versioning enabled

## Usage

1. Initialize Terraform:
   ```
   terraform init
   ```

2. Review the planned changes:
   ```
   terraform plan
   ```

3. Apply the configuration:
   ```
   terraform apply
   ```

4. To destroy the resources:
   ```
   terraform destroy
   ```

## Variables

The configuration uses variables defined in `variables.tf`. You can override these by creating a `terraform.tfvars` file or passing them via command line.