variable "project_name" {
  description = "Set the project name."
  type        = string
  default     = "test-manual-red-775"
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
  default     = "us-east-1"
}

variable "bucket_name" {
  description = "Set the name of the S3 bucket."
  type        = string
  default     = "test-manual-red-775-bucket"
}

variable "apex_domain" {
  description = "Set the apex domain."
  type        = string
  default     = "rag-space.com"
}

variable "record_name" {
  description = "Set the record name."
  type        = string
  default     = "test.rag-space.com"
}

variable "enable_static_website" {
  description = "Enable the creation of resources needed to support a secure and available static website."
  type        = bool
  default     = true
}

variable "website_path" {
  description = "Set the path to the website content."
  type        = string
  default     = "site"
}

module "static-website" {
  source = "../red-bucket"

  project_name          = var.project_name
  bucket_name           = var.bucket_name
  region                = var.region
  apex_domain           = var.apex_domain
  record_name           = var.record_name
  enable_static_website = var.enable_static_website
  website_path          = var.website_path
}

output "red_bucket_name" {
  value = module.static-website.red_bucket_name
}

output "website_url" {
  value = module.static-website.website_url
}

output "s3_url" {
  value = module.static-website.s3_url
}

output "website_record" {
  value = module.static-website.website_record
}
