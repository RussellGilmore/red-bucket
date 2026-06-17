####################################################################################################
# Required Variables

variable "project_name" {
  description = "Set the project name."
  type        = string
}

variable "region" {
  description = "Set the appropriate AWS region."
  type        = string
}

variable "bucket_name" {
  description = "Set the name of the S3 bucket."
  type        = string
}

####################################################################################################
# Optional Red Bucket Variables

variable "force_destroy" {
  description = "Set the force destroy option for the S3 bucket."
  type        = bool
  default     = true
}

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

variable "auth_lambda_arn" {
  description = "ARN of the Lambda@Edge function for authentication"
  type        = string
  default     = ""
}

variable "enable_authentication" {
  description = "Enable GitHub OAuth authentication"
  type        = bool
  default     = false
}
