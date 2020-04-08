#
# Look up the SSL certificate in AWS Certificate Manager for the provided domain.
#
data "aws_acm_certificate" "cert" {
  domain      = var.bucket_name
  most_recent = true
  types       = ["AMAZON_ISSUED"]
}

#
# Creates a CloudFront distribution for a given S3 bucket.
#
resource "aws_cloudfront_distribution" "cloudfront" {
  origin {
    domain_name = "${var.bucket_name}.s3.amazonaws.com"
    origin_id   = "${var.app_name}-${var.environment}"

    s3_origin_config {
      origin_access_identity = var.origin_access_identity
    }
  }

  aliases             = [var.bucket_name] # Alternate domain names, CNAMEs
  default_root_object = "index.html"
  enabled             = true    # Distribution State
  http_version        = "http2" # Supported HTTP Versions = HTTP/2, HTTP/1.1, HTTP/1.0
  is_ipv6_enabled     = true
  retain_on_delete    = false // if true, distribution is only disable on terraform destroy

  # Logging disabled.

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    compress               = true
    default_ttl            = var.cloudfront_ttl
    max_ttl                = var.cloudfront_ttl
    min_ttl                = 0
    target_origin_id       = "${var.app_name}-${var.environment}"
    viewer_protocol_policy = "redirect-to-https"

    forwarded_values {
      query_string = true

      cookies {
        forward = "all"
      }
    }
  }
  # Only USA and Europe; least expensive option
  price_class = "PriceClass_100"
  restrictions {
    geo_restriction {
      restriction_type = "none"

      #locations        = ["US", "CA", "GB", "DE"]
    }
  }
  tags = {
    Name        = "${var.environment}-${var.app_name}-cloudfront"
    Application = "${var.environment}-${var.app_name}"
    Billing     = "${var.environment}-${var.app_name}"
    Environment = "${var.environment}"
    Terraform   = "true"
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.1_2016" # Security Policy; TLSv1.1_2016 (recommended)
    ssl_support_method       = "sni-only"     # Custom SSL Client Support; vip incurs significant charges
  }
}
