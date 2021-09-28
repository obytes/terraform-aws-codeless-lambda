module "lambda" {
  source      = "./modules/lambda"
  prefix      = var.prefix
  common_tags = var.common_tags
  description = var.description

  envs        = var.envs
  runtime     = var.runtime
  handler     = var.handler
  timeout     = var.timeout
  memory_size = var.memory_size

  policy_json            = var.policy_json
  logs_retention_in_days = var.logs_retention_in_days
}
