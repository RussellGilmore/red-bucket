locals {
  # Tags applied to every taggable resource this module creates.
  # Replaces the embedded provider default_tags.
  tags = merge(
    {
      Orchestrator = "Terraform"
      Artifact     = "Red-Bucket"
      Project      = var.project_name
    },
    var.additional_tags
  )

  website_files      = var.enable_static_website ? fileset(var.website_path, "*") : []
  website_files_list = var.enable_static_website ? tolist(local.website_files) : []
}
