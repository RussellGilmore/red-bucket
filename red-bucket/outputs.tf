# Purpose: Return the name of the s3 bucket
output "red_bucket_name" {
  value       = aws_s3_bucket.red_bucket.bucket
  description = "The S3 bucket for storing whatever you want"
}

# # Purpose: Return the website URL for the CloudFront distribution
# output "website_url" {
#   description = "Website URL (HTTPS)"
#   value       = aws_cloudfront_distribution.distribution.domain_name
#   depends_on  = [aws_cloudfront_distribution.distribution]
# }

# # Purpose: Return the S3 hosting URL
# output "s3_url" {
#   description = "S3 hosting URL (HTTP)"
#   value       = aws_s3_bucket_website_configuration.hosting.website_endpoint
#   depends_on  = [aws_s3_bucket_website_configuration.hosting]
# }

# # Purpose: Return the Route 53 record for the website
# output "website_record" {
#   description = "Route 53 record for the website"
#   value       = aws_route53_record.record.name
#   depends_on  = [aws_route53_record.record]
# }
