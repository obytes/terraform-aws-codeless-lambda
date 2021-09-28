######################
#       OUTPUT       |
######################
output "lambda" {
  value = {
    name       = aws_lambda_function.function.function_name
    arn        = aws_lambda_function.function.arn
    runtime    = aws_lambda_function.function.runtime
    alias      = aws_lambda_alias.alias.name
    invoke_arn = aws_lambda_alias.alias.invoke_arn
  }
}
