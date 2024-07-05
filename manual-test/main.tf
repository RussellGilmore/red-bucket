module "static-website" {
  source = "../red-bucket"

  project_name          = "manual-test-54rg"
  region                = "us-east-1"
  apex_domain           = "rag-space.com"
  record_name           = "manual-test.rag-space.com"
  enable_static_website = true

}

# output "website_url" {
#   value = module.static-website.website_url
# }

# output "s3_url" {
#   value = module.static-website.s3_url
# }

# output "website_record" {
#   value = module.static-website.website_record
# }
