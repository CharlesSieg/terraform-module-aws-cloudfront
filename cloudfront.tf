resource "aws_cloudfront_distribution" "cloudfront" {
  aliases             = [var.bucket_name] # Alternate domain names, CNAMEs
  comment             = "CloudFront distribution for ${var.name}."
  default_root_object = "index.html"
  enabled             = true    # Distribution State
  http_version        = "http2" # Supported HTTP Versions = HTTP/2, HTTP/1.1, HTTP/1.0
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100" # Only USA and Europe; least expensive option
  retain_on_delete    = false            // if true, distribution is only disable on terraform destroy
  tags                = merge(var.tags, { Name = "${var.name_prefix}-${var.name}" })
  wait_for_deployment = false

  # Logging disabled.

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    default_ttl            = var.cloudfront_ttl
    max_ttl                = var.cloudfront_ttl
    min_ttl                = 0
    target_origin_id       = "${var.name_prefix}-${var.name}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = var.lambda_arn
      include_body = false
    }
  }

  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = "${var.name_prefix}-${var.name}"

    s3_origin_config {
      origin_access_identity = var.origin_access_identity
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.1_2016" # Security Policy; TLSv1.1_2016 (recommended)
    ssl_support_method       = "sni-only"     # Custom SSL Client Support; vip incurs significant charges
  }
}
