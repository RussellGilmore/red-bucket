# Purpose: Define the outputs for the backend S3 bucket
output "red_bucket_name" {
  value       = aws_s3_bucket.red-bucket.bucket
  description = "The S3 bucket for storing whatever you want"
}

output "website_url" {
  description = "Website URL (HTTPS)"
  value       = aws_cloudfront_distribution.distribution.domain_name
}

output "s3_url" {
  description = "S3 hosting URL (HTTP)"
  value       = aws_s3_bucket_website_configuration.hosting.website_endpoint
}

output "website_record" {
  description = "Route 53 record for the website"
  value       = aws_route53_record.record.name
}
