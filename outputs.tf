output "distribution_id" {
  description = "The unique identifier of the CloudFront distribution."
  value       = aws_cloudfront_distribution.cloudfront.id
}

output "domain_name" {
  description = "The domain name that points to the CloudFront distribution."
  value       = aws_cloudfront_distribution.cloudfront.domain_name
}

output "hosted_zone_id" {
  description = "The hosted zone ID for the domain that points to the CloudFront distribution."
  value       = aws_cloudfront_distribution.cloudfront.hosted_zone_id
}

output "lambda_arn" {
  description = "ARN of the Lambda function which handles CloudFront document misses."
  value       = aws_lambda_function.this.qualified_arn
}
