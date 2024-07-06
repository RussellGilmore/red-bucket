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
}
