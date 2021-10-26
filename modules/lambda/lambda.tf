###############################################
#                    Lambda                   |
###############################################
resource "aws_lambda_function" "function" {
  function_name = local.prefix
  publish       = true
  role          = aws_iam_role.role.arn

  # runtime
  runtime = var.runtime
  handler = var.handler

  # resources
  memory_size = var.memory_size
  timeout     = var.timeout

  # dummy package, package is delegated to CI pipeline
  filename = data.archive_file.dummy.output_path

  environment {
    variables = var.envs
  }

  tags = local.common_tags

  # LAMBDA CI is done through codebuild/codepipeline
  lifecycle {
    ignore_changes = [s3_key, s3_bucket, layers, filename]
  }
}

# Required by lambda provisioned concurency
resource "aws_lambda_alias" "alias" {
  name             = "latest"
  description      = "alias pointing to the latest published version of the lambda"
  function_name    = aws_lambda_function.function.function_name
  function_version = aws_lambda_function.function.version

  lifecycle {
    ignore_changes = [
      description,
      routing_config
    ]
  }
}
