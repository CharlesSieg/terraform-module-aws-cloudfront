variable "app_name" {
  description = "application name"
  type        = string
}

variable "aws_region" {
  description = "The AWS region in which the infrastructure will be provisioned."
  type        = string
}

variable "bucket_name" {
  description = "Name of the S3 bucket which contains the dashboard source code"
  type        = string
}

variable "cloudfront_ttl" {
  description = "How many seconds an object remains in cache"
  type        = number
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "origin_access_identity" {
  description = "The Origin Access Identity giving CloudFront permission to access the corresponding S3 bucket."
  type        = string
}
