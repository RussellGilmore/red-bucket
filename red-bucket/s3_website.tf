resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.red-bucket.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket_public_access_block.s3_public_access_block]
  bucket     = aws_s3_bucket.red-bucket.id
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
            aws_s3_bucket.red-bucket.arn,
            "${aws_s3_bucket.red-bucket.arn}/*",
          ]
        }
      ]
    }
  )
}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = "Example origin access identity"
}

resource "aws_cloudfront_distribution" "distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Example distribution"
  default_root_object = "index.html"
  price_class         = "PriceClass_100"

  aliases = [var.record_name]

  origin {
    domain_name = aws_s3_bucket.red-bucket.bucket_regional_domain_name
    origin_id   = var.project_name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }
  }



  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.example_cert.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

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

resource "aws_s3_object" "file" {
  for_each     = fileset(path.module, "${var.website_path}/**/*.{html,css,js}")
  bucket       = aws_s3_bucket.red-bucket.id
  key          = replace(each.value, "/^${var.website_path}//", "")
  source       = each.value
  content_type = lookup(local.content_types, regex("\\.[^.]+$", each.value), null)
  source_hash  = filemd5(each.value)
}

# Route 53 Section

# Fetch the existing hosted zone
data "aws_route53_zone" "example" {
  name = var.apex_domain
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = var.record_name
  type    = "CNAME"
  ttl     = 300

  records = [aws_cloudfront_distribution.distribution.domain_name]
}

resource "aws_acm_certificate" "example_cert" {
  domain_name       = var.record_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Create DNS validation records
resource "aws_route53_record" "example_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.example_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = data.aws_route53_zone.example.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

# Wait for DNS validation to complete
resource "aws_acm_certificate_validation" "example_cert_validation" {
  certificate_arn         = aws_acm_certificate.example_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.example_cert_validation : record.fqdn]
}
