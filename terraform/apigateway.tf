data "aws_api_gateway_rest_api" "desserts_rest_api" {
  name = "desserts-api-gateway"
}

data "aws_api_gateway_domain_name" "desserts_domain_name" {
  domain_name = var.environment == "prod" ? "desserts-api.megsparadisecakes.com" : "desserts-dev-api.megsparadisecakes.com"
}
