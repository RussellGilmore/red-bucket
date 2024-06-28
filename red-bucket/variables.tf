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

variable "zone_id" {
  description = "Set the Route 53 zone ID."
  type        = string
  default     = ""
}

variable "domain" {
  description = "Set the domain name."
  type        = string
  default     = ""
}

variable "enable_public_block" {
  description = "Enable public access block."
  type        = bool
  default     = true
}

variable "website_path" {
  description = "Set the path to the website content."
  type        = string
  default     = "../site"
}
