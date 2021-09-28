###############################################
#                 LAMBDA POLICY               |
###############################################
resource "aws_iam_policy" "managed_policy" {
  name   = "${local.prefix}-managed"
  path   = "/"
  policy = data.aws_iam_policy.managed_policy.policy
}

data "aws_iam_policy" "managed_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

###############################################
#                 LAMBDA POLICY               |
###############################################
resource "aws_iam_policy" "custom_policy" {
  count  = var.policy_json == null ? 0:1
  name   = "${local.prefix}-custom"
  path   = "/"
  policy = var.policy_json
}

###############################################
#                 LAMBDA ROLE                 |
###############################################
resource "aws_iam_role" "role" {
  name               = local.prefix
  assume_role_policy = data.aws_iam_policy_document.role.json
}

data "aws_iam_policy_document" "role" {
  statement {
    effect = "Allow"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


###############################################
#        LAMBDA ROLE/POLICY ATTACHMENT        |
###############################################
resource "aws_iam_role_policy_attachment" "attach_managed_policy" {
  policy_arn = aws_iam_policy.managed_policy.arn
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "attach_custom_policy" {
  count      = var.policy_json == null ? 0:1
  policy_arn = aws_iam_policy.custom_policy[0].arn
  role       = aws_iam_role.role.name
}


