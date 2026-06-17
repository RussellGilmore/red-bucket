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

# Origin Access Control — the modern replacement for Origin Access Identity.
# OAC supports SigV4, all regions, and SSE-KMS origins; OAI is legacy.
resource "aws_cloudfront_origin_access_control" "default" {
  count                             = var.enable_static_website ? 1 : 0
  name                              = "${var.project_name}-${var.bucket_name}-oac"
  description                       = "Red Bucket origin access control"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# Bucket policy granting the CloudFront distribution read access via OAC.
# OAC authorizes by service principal + source distribution ARN rather than
# the OAI's IAM-user-style principal.
resource "aws_s3_bucket_policy" "bucket_policy" {
  count      = var.enable_static_website ? 1 : 0
  depends_on = [aws_s3_bucket_public_access_block.s3_public_access_block]
  bucket     = aws_s3_bucket.red_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.red_bucket.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.distribution[0].arn
          }
        }
      }
    ]
  })
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

  tags = local.tags

  origin {
    domain_name              = aws_s3_bucket.red_bucket.bucket_regional_domain_name
    origin_id                = var.project_name
    origin_access_control_id = aws_cloudfront_origin_access_control.default[0].id
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.public_cert[0].arn
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
      query_string = var.enable_authentication ? true : false
      headers      = var.enable_authentication ? ["Authorization", "CloudFront-Viewer-Country"] : []
      cookies {
        forward = var.enable_authentication ? "all" : "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = var.enable_authentication ? 0 : 3600
    max_ttl                = var.enable_authentication ? 3600 : 86400

    dynamic "lambda_function_association" {
      for_each = var.enable_authentication && var.auth_lambda_arn != "" ? [1] : []
      content {
        event_type   = "viewer-request"
        lambda_arn   = var.auth_lambda_arn
        include_body = false
      }
    }
  }

  dynamic "custom_error_response" {
    for_each = var.enable_authentication ? [
      {
        error_code         = 403
        response_code      = 403
        response_page_path = "/403.html"
      },
      {
        error_code         = 404
        response_code      = 404
        response_page_path = "/404.html"
      }
    ] : []

    content {
      error_code         = custom_error_response.value.error_code
      response_code      = custom_error_response.value.response_code
      response_page_path = custom_error_response.value.response_page_path
    }
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
  zone_id = data.aws_route53_zone.zone[0].zone_id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300

  records = [aws_cloudfront_distribution.distribution[0].domain_name]
}

# Create an ACM certificate for the domain name
resource "aws_acm_certificate" "public_cert" {
  count             = var.enable_static_website ? 1 : 0
  domain_name       = var.record_name
  validation_method = "DNS"

  tags = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

# DNS validation records for the ACM certificate.
# Iterates the cert's domain_validation_options as a keyed map so the record
# count tracks the actual number of validation entries instead of assuming one.
resource "aws_route53_record" "public_cert_validation" {
  for_each = var.enable_static_website ? {
    for dvo in aws_acm_certificate.public_cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id         = data.aws_route53_zone.zone[0].zone_id
  name            = each.value.name
  type            = each.value.type
  records         = [each.value.record]
  ttl             = 60
  allow_overwrite = true
}

# Validate the ACM certificate
resource "aws_acm_certificate_validation" "public_cert_validation" {
  count                   = var.enable_static_website ? 1 : 0
  certificate_arn         = aws_acm_certificate.public_cert[0].arn
  validation_record_fqdns = [for record in aws_route53_record.public_cert_validation : record.fqdn]
}
