#
# Create the IAM role and associated policies for executing the lambda function.
#
data "aws_iam_policy_document" "lambda_assume_role" {
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

data "aws_iam_policy_document" "lambda_permissions" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    effect    = "Allow"
    resources = ["*"]
    sid       = "AllowWriteToCloudwatchLogs"
  }
}

resource "aws_iam_role" "lambda_execution" {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
  name               = "${var.name_prefix}-${var.name}-lambda-execution-role"
}

resource "aws_iam_role_policy" "lambda_execution" {
  name   = "${var.name_prefix}-${var.name}-lambda-execution-role-policy"
  policy = data.aws_iam_policy_document.lambda_permissions.json
  role   = aws_iam_role.lambda_execution.id
}
