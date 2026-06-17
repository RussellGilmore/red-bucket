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
  default = "data"
}

provider "aws" {
  region = var.region
}

module "bucket" {
  source = "../../"

  project_name = var.project_name
  bucket_name  = var.bucket_name

  additional_tags = {
    Environment = "example"
  }
}

output "red_bucket_name" {
  value = module.bucket.red_bucket_name
}
