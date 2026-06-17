# Purpose: Return the name of the s3 bucket
output "red_bucket_name" {
  value       = aws_s3_bucket.red_bucket.bucket
  description = "The S3 bucket for storing whatever you want"
}

# # Purpose: Return the website URL for the CloudFront distribution
output "website_url" {
  description = "Website URL (HTTPS)"
  value       = var.enable_static_website ? aws_cloudfront_distribution.distribution[0].domain_name : "Static website not enabled."
}

# Purpose: Return the S3 hosting URL
output "s3_url" {
  description = "S3 hosting URL (HTTP)"
  value       = var.enable_static_website ? aws_s3_bucket_website_configuration.hosting[0].website_endpoint : "Static website not enabled."
}

# Purpose: Return the Route 53 record for the website
output "website_record" {
  description = "Route 53 record for the website"
  value       = var.enable_static_website ? aws_route53_record.record[0].name : "Static website not enabled."
}
