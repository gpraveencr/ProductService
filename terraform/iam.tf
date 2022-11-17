
# IAM Policies

resource "aws_iam_role" "ProductLambdaRole" {
  name               = "ProductLambdaRole"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "ProductLambdaPolicy" {
  name        = "ProductLambdaPolicy"
  description = "IAM policy for Product Lambda Functions"
  path        = "/"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "logs:CreateLogStream",
          "logs:CreateLogGroup",
          "logs:PutLogEvents"
        ],
        "Resource" : "arn:aws:logs:*:*:*"
      },
      {
        "Effect" : "Allow",
        "Action" : ["dynamodb:PutItem"],
        "Resource" : "arn:aws:dynamodb:*:*:table/PRODUCT"
      }
    ]
    }
  )
}

resource "aws_iam_role_policy_attachment" "ProductLambdaRolePolicy" {
  role       = aws_iam_role.ProductLambdaRole.name
  policy_arn = aws_iam_policy.ProductLambdaPolicy.arn
}
