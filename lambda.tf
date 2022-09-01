#
# Zip up the lambda source code and create the lambda function.
#
data "archive_file" "this" {
  output_path = "${path.module}/.files/cloudfront-document-miss-redirect.zip"
  source_file = "${path.module}/source/index.js"
  type        = "zip"
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.this.output_path
  function_name    = local.function_name
  handler          = "index.handler"
  publish          = true
  role             = aws_iam_role.lambda_execution.arn
  runtime          = "nodejs14.x"
  source_code_hash = data.archive_file.this.output_base64sha256
  tags             = merge(var.tags, { Name = local.function_name })

  depends_on = [
    aws_cloudwatch_log_group.this,
    aws_iam_role_policy.lambda_execution
  ]
}
