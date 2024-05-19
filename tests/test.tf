variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

module "red-bucket" {
  source = "../red-bucket"

  project_name = var.project_name
  region       = var.region
}

output "red_bucket_s3_bucket" {
  value       = module.red-bucket.red_bucket_name
  description = "The S3 bucket for storing Terraform state files"
}
