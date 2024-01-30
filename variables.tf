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

variable "lambda_arn" {
  description = ""
  type        = string
}

variable "name" {
  description = "application name"
  type        = string
}

variable "name_prefix" {
  description = ""
  type        = string
}

variable "origin_access_identity" {
  description = "The Origin Access Identity giving CloudFront permission to access the corresponding S3 bucket."
  type        = string
}

variable "origin_path" {
  default = null
  description = "Optional element that causes CloudFront to request your content from a directory in your Amazon S3 bucket or your custom origin."
  type = string
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to resources."
  type        = map(string)
}
