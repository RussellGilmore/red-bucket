# locals {
#   content_types = {
#     ".html" : "text/html",
#     ".css" : "text/css",
#     ".js" : "text/javascript"
#   }
# }

locals {
  website_files      = var.enable_static_website ? fileset(var.website_path, "*") : []
  website_files_list = var.enable_static_website ? tolist(local.website_files) : []
  public_cert_validation_options = var.enable_static_website ? [
    for dvo in aws_acm_certificate.public_cert.domain_validation_options : {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  ] : []
}
