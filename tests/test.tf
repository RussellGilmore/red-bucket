variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

variable "apex_domain" {
  description = "Set the apex domain."
  type        = string
}

variable "record_name" {
  description = "Set the record name."
  type        = string
}

module "static-website" {
  source = "../red-bucket"

  project_name        = var.project_name
  region              = var.region
  apex_domain         = var.apex_domain
  record_name         = var.record_name
  enable_public_block = false
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
