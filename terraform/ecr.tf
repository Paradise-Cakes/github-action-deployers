data "aws_ecr_repository" "desserts_api_repository" {
  name = var.environment == "prod" ? "desserts-api-lambdas-us-east-1" : "dev-desserts-api-lambdas-us-east-1"
}

data "aws_ecr_repository" "orders_api_repository" {
  name = var.environment == "prod" ? "orders-api-lambdas-us-east-1" : "dev-orders-api-lambdas-us-east-1"
}
