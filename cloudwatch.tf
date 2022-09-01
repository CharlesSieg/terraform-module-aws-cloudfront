resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = var.cloudwatch_logs_retention_in_days
  tags              = merge(var.tags, { Name = "/aws/lambda/${local.function_name}" })
}
