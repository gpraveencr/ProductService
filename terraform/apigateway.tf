
# APIGateway Policies

resource "aws_api_gateway_rest_api" "product_apigw" {
  name        = "product_apigw"
  description = "Product API Gateway"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "product" {
  rest_api_id = aws_api_gateway_rest_api.product_apigw.id
  parent_id   = aws_api_gateway_rest_api.product_apigw.root_resource_id
  path_part   = "product"
}

resource "aws_api_gateway_method" "create_product" {
  rest_api_id   = aws_api_gateway_rest_api.product_apigw.id
  resource_id   = aws_api_gateway_resource.product.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "createproduct-lambda" {
  rest_api_id             = aws_api_gateway_rest_api.product_apigw.id
  resource_id             = aws_api_gateway_method.create_product.resource_id
  http_method             = aws_api_gateway_method.create_product.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.CreateProductHandler.invoke_arn
}
resource "aws_lambda_permission" "apigw-CreateProductHandler" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.CreateProductHandler.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.product_apigw.execution_arn}/*/POST/product"
}
resource "aws_api_gateway_deployment" "productapistageprod" {
  depends_on = [
    aws_api_gateway_integration.createproduct-lambda
  ]
  rest_api_id = aws_api_gateway_rest_api.product_apigw.id
  stage_name  = "prod"
}
