#
# Look up the SSL certificate in AWS Certificate Manager for the provided domain.
#
data "aws_acm_certificate" "cert" {
  domain      = var.bucket_name
  most_recent = true
  types       = ["AMAZON_ISSUED"]
}
