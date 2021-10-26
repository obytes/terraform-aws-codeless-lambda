locals {
  prefix      = "${var.prefix}-codeless"
  common_tags = merge(
    var.common_tags,
    {
      module      = "lambda-aws-codeless-lambda"
      description = var.description
    }
  )
}
