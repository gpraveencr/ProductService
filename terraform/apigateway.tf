
resource "aws_api_gateway_rest_api" "product_apigw" {
  name = "product_apigw"
  description = "Product API Gateway"
  endpoint_configuration {
    types = [ "REGIONAL" ]
  }
}

resource "aws_api_gateway_resource" "product" {
  rest_api_id = aws_api_gateway_rest_api.product_apigw.id
  parent_id = aws_api_gateway_rest_api.product_apigw.root_resource_id
  path_part = "product"
}

resource "aws_api_gateway_method" "create_product" {
  rest_api_id = aws_api_gateway_rest_api.product_apigw.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = "POST"
  authorization = "NONE"
}
