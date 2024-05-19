# Purpose: Define the outputs for the backend S3 bucket
output "red_bucket_name" {
  value       = aws_s3_bucket.red-bucket.bucket
  description = "The S3 bucket for storing whatever you want"
}
