locals {
  prefix      = "${var.prefix}-codeless"
  common_tags = merge(
    var.common_tags,
    {
      module      = "lambda-aws-codeless-lambda"
      description = var.description
    }
  )

  # Workaround https://github.com/hashicorp/terraform/issues/26755#issuecomment-794258499
  custom_policy_json = var.policy_json[*]
}
