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

# Enable Static Website Variable Section
variable "enable_static_website" {
  description = "Enable the creation of resources needed to support a secure and available static website."
  type        = bool
  default     = false
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
