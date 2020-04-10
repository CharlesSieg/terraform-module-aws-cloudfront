###########################################################
###########################################################
# CLIENT FILES CLOUDFRONT LAMBDA
###########################################################
###########################################################
#
# Create the IAM role and associated policies for executing the lambda function.
#
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      identifiers = [
        "edgelambda.amazonaws.com",
        "lambda.amazonaws.com",
      ]
      type = "Service"
    }
  }
}
data "aws_iam_policy_document" "permissions" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetRandomPassword",
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:ListSecretVersionIds",
    ]
    effect    = "Allow"
    resources = ["*"]
    sid       = "DefaultDocumentMissLambdaPermissions"
  }
}
resource "aws_iam_role" "lambda_execution_role" {
  assume_role_policy = "${data.aws_iam_policy_document.assume_role.json}"
  name               = "${var.environment}-${var.app_name}-lambda-execution-role"
}
resource "aws_iam_role_policy" "lambda_execution_role" {
  name   = "${var.environment}-${var.app_name}-lambda-execution-role-policy"
  policy = "${data.aws_iam_policy_document.permissions.json}"
  role   = "${aws_iam_role.lambda_execution_role.id}"
}
#
# Zip up the lambda source code and create the lambda function.
#
data "archive_file" "lambda" {
  output_path = "${path.module}/.files/defaultDocumentMiss.zip"
  source_file = "${path.module}/source/defaultDocumentMiss/index.js"
  type        = "zip"
}
resource "aws_lambda_function" "lambda" {
  filename         = "${data.archive_file.lambda.output_path}"
  function_name    = "${var.environment}-${var.app_name}-defaultDocumentMiss"
  handler          = "index.handler"
  publish          = true
  role             = "${aws_iam_role.lambda_execution_role.arn}"
  runtime          = "nodejs10.x"
  source_code_hash = "${data.archive_file.lambda.output_base64sha256}"
}


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

    lambda_function_association {
      event_type   = "viewer-request"
      lambda_arn   = "${aws_lambda_function.lambda.qualified_arn}"
      include_body = false
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
    Environment = var.environment
    Terraform   = "true"
  }
  viewer_certificate {
    acm_certificate_arn      = data.aws_acm_certificate.cert.arn
    minimum_protocol_version = "TLSv1.1_2016" # Security Policy; TLSv1.1_2016 (recommended)
    ssl_support_method       = "sni-only"     # Custom SSL Client Support; vip incurs significant charges
  }
}
