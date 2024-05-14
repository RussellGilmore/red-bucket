# Provider configuration with default tags
provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Orchestrator = "Terraform"
      Artifact     = "Red-Backend"
      Project      = var.project_name
    }
  }
}

# Data sources for current AWS account, partition, and region
data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}
data "aws_region" "current" {}

# Terraform Statefile Bucket
resource "aws_s3_bucket" "backend_s3" {
  bucket = "${var.project_name}-s3"
}

# Server-side encryption configuration for the S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.backend_s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Enable versioning for the S3 bucket
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.backend_s3.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable public access block for the S3 bucket
resource "aws_s3_bucket_public_access_block" "s3_public_access_block" {
  bucket = aws_s3_bucket.backend_s3.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table for Terraform state lock
resource "aws_dynamodb_table" "ddb_lock_status_table" {
  name         = "${var.project_name}-tf-lock-status"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}

# IAM policy to access the S3 bucket and DynamoDB table
resource "aws_iam_policy" "s3_ddb_policy" {
  name        = "${var.project_name}-Backend-Resource-Policy"
  description = "IAM policy to access the S3 bucket and DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.backend_s3.id}"]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = ["arn:${data.aws_partition.current.partition}:s3:::${aws_s3_bucket.backend_s3.id}/*"]
      },
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
        Resource = ["arn:${data.aws_partition.current.partition}:dynamodb:*:*:table/${aws_dynamodb_table.ddb_lock_status_table.id}"]
    }]
  })
}
