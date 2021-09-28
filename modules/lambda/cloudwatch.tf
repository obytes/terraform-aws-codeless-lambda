###############################################
#              LAMBDA LOG GROUP               |
###############################################
resource "aws_cloudwatch_log_group" "default" {
  name              = "/aws/lambda/${local.prefix}"
  retention_in_days = var.logs_retention_in_days

  tags = merge(
    local.common_tags,
    map(
      "description", var.description
    )
  )
}
