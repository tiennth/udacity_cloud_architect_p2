provider "aws" {
  region     = var.aws_region
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy" "lambda_allow_cloudwatch_logs" {
  name = "AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.iam_for_lambda.name
  policy_arn = data.aws_iam_policy.lambda_allow_cloudwatch_logs.arn
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "greet_lambda.py"
  output_path = "greet_lambda_payload.zip"
}

resource "aws_lambda_function" "sample_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "greet_lambda_payload.zip"
  function_name = "greet_lambda"
  role          = aws_iam_role.iam_for_lambda.arn

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.8"

  handler = "greet_lambda.lambda_handler"

    environment {
      variables = {
        greeting = "Hello"
      }
    }
}
