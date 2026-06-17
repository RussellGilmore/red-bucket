variable "project_name" {
  type    = string
  default = "red-bucket-example"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "bucket_name" {
  type    = string
  default = "site"
}

variable "apex_domain" {
  description = "Apex domain with a Route53 hosted zone you control."
  type        = string
}

variable "record_name" {
  description = "FQDN for the site, e.g. demo.example.com"
  type        = string
}

# ACM certs for CloudFront must live in us-east-1.
provider "aws" {
  region = var.region
}

module "static_website" {
  source = "../../"

  project_name          = var.project_name
  bucket_name           = var.bucket_name
  apex_domain           = var.apex_domain
  record_name           = var.record_name
  enable_static_website = true
  website_path          = "${path.module}/site"
  force_destroy         = true

  additional_tags = {
    Environment = "example"
  }
}

output "website_url" {
  value = module.static_website.website_url
}

output "red_bucket_name" {
  value = module.static_website.red_bucket_name
}
