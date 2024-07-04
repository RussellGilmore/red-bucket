variable "project_name" {
  description = "Set the project name."
  type        = string
  default     = "red-test"
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
  default     = "us-east-1"
}

variable "s3_website" {
  description = "Map containing static web-site hosting or redirect configuration."
  type        = any
  default     = {}
}

variable "enable_public_block" {
  description = "Enable public access block. (Must be disabled for static website hosting))"
  type        = bool
  default     = true
}

variable "apex_domain" {
  description = "Set the domain name."
  type        = string
  default     = ""
}

variable "record_name" {
  description = "Set the sub-domain name."
  type        = string
  default     = ""
}

variable "website_path" {
  description = "Set the path to the website content."
  type        = string
  default     = "../site"
}
