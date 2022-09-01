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

variable "cloudwatch_logs_retention_in_days" {
  default     = 3
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, 3653, and 0. If you select 0, the events in the log group are always retained and never expire."
  type        = number
}

variable "name_prefix" {
  description = ""
  type        = string
}

variable "origin_access_identity" {
  description = "The Origin Access Identity giving CloudFront permission to access the corresponding S3 bucket."
  type        = string
}

variable "tags" {
  default     = {}
  description = "A mapping of tags to assign to resources."
  type        = map(string)
}
