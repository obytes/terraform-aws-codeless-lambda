# Terraform aws codeless lambda

Decoupling AWS Lambda code/dependencies continuous integration/deployment from Terraform to external CI service like 
codebuild/codepipeline, github actions or circle CI...

## Concept

This module achieves that by providing a dummy code package to Terraform Lambda resource and instructing terraform to 
ignore any changes affecting `s3_key`, `s3_bucket`, `layers` and `filename` attributes. as they will be changed by an 
external CI service. and we don’t want Terraform to revert those changes on every deploy.

Since the lambda version will be changed constantly, the module also creates an alias with the name `latest` and on each 
deploy the external CI service can update the alias with the new deployed lambda version.

The main advantage of Lambda alias is to avoid other resources depending on the lambda function from invoking a broken 
lambda function version, and they will always invoke the latest stable version that the CI process have tagged with 
`latest` alias at the end of the pipeline.

The other advantage is the ability for other services to invoke `latest` version without needing to update those 
services whenever the function version changes.

> A lambda alias is required in case you want to implement provisioned concurrency afterwards.

## Usage

### Creating Lambda

```hcl
module "lambda" {
  source      = "git::https://github.com/obytes/terraform-aws-codeless-lambda.git//modules/lambda"
  prefix      = "demo-api"
  common_tags = {env = "test", stack = "demos"}
  description = "Terraform is my creator but Codepipeline is the demon I listen to"
  
  envs        = {API_KEY = "not-secret"}
  runtime     = "python3.9"
  handler     = "app.handler"
  timeout     = 29
  memory_size = 1024
  
  policy_json            = data.aws_iam_policy_document.policy.json
  logs_retention_in_days = 14
}
```

### Hook it to CI pipeline

- Manual CI using [aws-lambda-ci](https://github.com/obytes/aws-lambda-ci):

In case you are still developing your function locally and you want to start a manual CI you can use `aws-lambda-ci`.

```bash
pip3 install aws-lambda-ci
aws-lambda-ci \
--app-s3-bucket "demo-artifacts" \
--function-name "demo-api" \
--function-runtime "python3.9" \
--function-alias-name "latest" \
--function-layer-name "demo-api-deps" \
--app-src-path "src" \
--app-packages-descriptor-path "requirements.txt" \
--source-version "1.0.2" \
--aws-profile-name "kodhive_prd" \
--watch-log-stream
```

- Automated CI using [terraform-aws-lambda-ci](https://github.com/obytes/terraform-aws-lambda-ci)

In case your lambda function is already version controlled in Github, You can trigger CI Pipeline in response to Github
webhook events like `push` to a branch or a tag `release`.

```hcl
module "lambda_ci" {
  source      = "git::https://github.com/obytes/terraform-aws-lambda-ci.git//modules/ci"
  prefix      = "demo-api-ci"
  common_tags = {env = "test", stack = "demos-ci"}

  lambda                   = module.lambda.lambda
  app_src_path             = "src"
  packages_descriptor_path = "requirements.txt"

  # Github
  s3_artifacts = {
    arn    = aws_s3_bucket.artifacts.arn
    bucket = aws_s3_bucket.artifacts.bucket
  }
  pre_release  = true
  github       = {
    owner          = "obytes"
    token          = "gh_123456789876543234567845678"
    webhook_secret = "not-secret"
    connection_arn = "[GH_CODESTAR_CONNECTION_ARN]"
  }
  github_repository = {
    name   = "demo-api"
    branch = "main"
  }

  # Notifications
  ci_notifications_slack_channels = {
    info  = "ci-info"
    alert = "ci-alert"
  }
}
```

> [terraform-aws-lambda-ci](https://github.com/obytes/terraform-aws-lambda-ci) is leveraging 
> [aws-lambda-ci](https://github.com/obytes/aws-lambda-ci) in the background!


### More info

You can read this [article](https://www.obytes.com/blog/go-serverless-part-2-terraform-and-aws-lambda-external-ci) for 
more details.
