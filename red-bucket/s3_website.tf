# This data source is used to get the hosted zone ID for the domain name
data "aws_route53_zone" "zone" {
  count = var.enable_static_website ? 1 : 0
  name  = var.apex_domain
}

# Configure the S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "hosting" {
  count  = var.enable_static_website ? 1 : 0
  bucket = aws_s3_bucket.red_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Configure the S3 bucket for public access for static website hosting
resource "aws_s3_bucket_policy" "bucket_policy" {
  count      = var.enable_static_website ? 1 : 0
  depends_on = [aws_s3_bucket_public_access_block.s3_public_access_block]
  bucket     = aws_s3_bucket.red_bucket.id
  policy = jsonencode(
    {
      "Version" = "2012-10-17",
      "Statement" = [
        {
          "Sid"       = "PublicReadGetObject",
          "Effect"    = "Allow",
          "Principal" = "*",
          "Action" = [
            "s3:GetObject"
          ],
          "Resource" = [
            aws_s3_bucket.red_bucket.arn,
            "${aws_s3_bucket.red_bucket.arn}/*",
          ]
        }
      ]
    }
  )
}

# Creates an origin access identity for the CloudFront distribution
resource "aws_cloudfront_origin_access_identity" "default" {
  count   = var.enable_static_website ? 1 : 0
  comment = "Red Bucket origin access identity"
}

# Configure the CloudFront distribution for the static website
resource "aws_cloudfront_distribution" "distribution" {
  count               = var.enable_static_website ? 1 : 0
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Red Bucket Distribution"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  aliases = [var.record_name]

  origin {
    domain_name = aws_s3_bucket.red_bucket.bucket_regional_domain_name
    origin_id   = var.project_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default[0].cloudfront_access_identity_path
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.public_cert[count.index].arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Restrict access to the CloudFront distribution to US only
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = var.project_name

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }
}

# Upload files to S3 bucket if enable_static_website is true
resource "aws_s3_object" "website_files" {
  count = var.enable_static_website ? length(local.website_files_list) : 0

  bucket = aws_s3_bucket.red_bucket.id
  key    = local.website_files_list[count.index]
  source = "${var.website_path}/${local.website_files_list[count.index]}"
  etag   = filemd5("${var.website_path}/${local.website_files_list[count.index]}")

  content_type = lookup({
    html = "text/html",
    css  = "text/css",
    js   = "application/javascript",
    png  = "image/png",
    jpg  = "image/jpeg",
    gif  = "image/gif"
  }, regex(".*\\.(.*)$", local.website_files_list[count.index])[0], "application/octet-stream")
}

# Create a Route 53 record for the CloudFront distribution
resource "aws_route53_record" "record" {
  count   = var.enable_static_website ? 1 : 0
  zone_id = data.aws_route53_zone.zone[count.index].zone_id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300

  records = var.enable_static_website ? [aws_cloudfront_distribution.distribution[0].domain_name] : []
}

# Create an ACM certificate for the domain name
resource "aws_acm_certificate" "public_cert" {
  count             = var.enable_static_website ? 1 : 0
  domain_name       = var.record_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Create a Route 53 record for the ACM certificate validation
resource "aws_route53_record" "public_cert_validation" {
  count   = var.enable_static_website ? length(tolist(aws_acm_certificate.public_cert[0].domain_validation_options)) : 0
  zone_id = data.aws_route53_zone.zone[count.index].zone_id
  name    = var.enable_static_website ? tolist(aws_acm_certificate.public_cert[0].domain_validation_options)[count.index].resource_record_name : ""
  type    = var.enable_static_website ? tolist(aws_acm_certificate.public_cert[0].domain_validation_options)[count.index].resource_record_type : ""
  ttl     = 60
  records = var.enable_static_website ? [tolist(aws_acm_certificate.public_cert[0].domain_validation_options)[count.index].resource_record_value] : []
}

# Validate the ACM certificate
resource "aws_acm_certificate_validation" "public_cert_validation" {
  count                   = var.enable_static_website ? 1 : 0
  certificate_arn         = aws_acm_certificate.public_cert[count.index].arn
  validation_record_fqdns = var.enable_static_website ? [for record in aws_route53_record.public_cert_validation : record.fqdn] : []
}
