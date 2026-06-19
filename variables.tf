####################################################################################################
# Required Variables

variable "project_name" {
  description = "Project name used for resource naming and the Project tag."
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket (combined with project_name)."
  type        = string
}

####################################################################################################
# Optional Red Bucket Variables

variable "additional_tags" {
  description = "Additional tags to apply to all resources created by this module."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the bucket even when it contains objects. Defaults to false to protect against accidental data loss; set true for ephemeral or test buckets."
  type        = bool
  default     = false
}

variable "enable_static_website" {
  description = "Create the CloudFront + ACM + Route53 resources needed to serve the bucket as a secure static website."
  type        = bool
  default     = false
}

variable "apex_domain" {
  description = "Apex domain whose Route53 hosted zone holds the website records. Required when enable_static_website is true."
  type        = string
  default     = ""
}

variable "record_name" {
  description = "Fully-qualified record name for the website (e.g. app.example.com). Required when enable_static_website is true."
  type        = string
  default     = ""
}

variable "website_path" {
  description = "Path to the static website content to upload."
  type        = string
  default     = "../site"
}

variable "auth_lambda_arn" {
  description = "ARN of a Lambda@Edge function for viewer-request authentication. Must be set when enable_authentication is true."
  type        = string
  default     = ""
}

variable "enable_authentication" {
  description = "Enable Lambda@Edge-based authentication on the CloudFront distribution."
  type        = bool
  default     = false
}

variable "logging_bucket" {
  description = "Domain name of an S3 bucket to receive CloudFront access logs (e.g. my-logs.s3.amazonaws.com). When empty, access logging is disabled. The bucket must have ACLs enabled and grant the awslogsdelivery account write access."
  type        = string
  default     = ""
}

variable "logging_prefix" {
  description = "Object key prefix for CloudFront access logs within logging_bucket."
  type        = string
  default     = "cloudfront/"
}
