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

variable "enable_static_website" {
  description = "Enable the creation of resources needed to support a secure and available static website."
  type        = bool
}

module "static-website" {
  source = "../red-bucket"

  project_name          = var.project_name
  region                = var.region
  apex_domain           = var.apex_domain
  record_name           = var.record_name
  enable_static_website = var.enable_static_website
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
