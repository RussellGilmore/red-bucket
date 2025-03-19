# Provider configuration with default tags
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Orchestrator = "Terraform"
      Artifact     = "Red-Bucket"
      Project      = var.project_name
    }
  }
}

# Data sources for current AWS account, partition, and region
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# S3 bucket resource
resource "aws_s3_bucket" "red_bucket" {
  bucket        = "${var.project_name}-s3"
  force_destroy = var.force_destroy
}

# Server-side encryption configuration for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.red_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.red_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable public access block for the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.red_bucket.id

  block_public_acls       = var.enable_static_website ? false : true
  block_public_policy     = var.enable_static_website ? false : true
  ignore_public_acls      = var.enable_static_website ? false : true
  restrict_public_buckets = var.enable_static_website ? false : true
}
