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
