module "static-website" {
  source = "../red-bucket"

  project_name        = "manual-test-54rg"
  region              = "us-east-1"
  zone_id             = "Z1U6LA83P9X5OM"
  domain              = "wedding.russellgilmore.net"
  enable_public_block = false
}

output "website_url" {
  value = module.static-website.website_url
}

output "s3_url" {
  value = module.static-website.s3_url
}
