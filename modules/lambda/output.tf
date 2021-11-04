######################
#       OUTPUT       |
######################
output "lambda" {
  value = {
    name       = aws_lambda_function.function.function_name
    arn        = aws_lambda_function.function.arn
    runtime    = aws_lambda_function.function.runtime
    alias      = aws_lambda_alias.alias.name
    alias_arn  = aws_lambda_alias.alias.arn
    invoke_arn = aws_lambda_alias.alias.invoke_arn
  }
}

output "role" {
  value = {
    arn  = aws_iam_role.role.arn
    name = aws_iam_role.role.name
  }
}