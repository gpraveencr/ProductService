
resource "aws_lambda_function" "CreateProductHandler" {
  function_name = "CreateProductHandler"
  filename      = "../lambda/product_lambda.zip"
  handler       = "createproduct.lambda_handler"
  runtime       = "python3.8"
  environment {
    variables = {
      REGION        = "us-east-2"
      PRODUCT_TABLE = aws_dynamodb_table.product_table.name
    }
  }
  source_code_hash = filebase64sha256("../lambda/product_lambda.zip")
  role             = aws_iam_role.ProductLambdaRole.arn
  timeout          = "5"
  memory_size      = "128"
}
