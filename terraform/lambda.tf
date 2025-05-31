data "aws_lambda_function" "desserts_api" {
  function_name = "desserts-api-us-east-1"
}

data "aws_lambda_function" "orders_api" {
  function_name = "orders-api-us-east-1"
}
