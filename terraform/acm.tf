data "aws_acm_certificate" "desserts_api_cert" {
  domain = var.environment == "prod" ? "desserts-api.megsparadisecakes.com" : "desserts-dev-api.megsparadisecakes.com"
}

data "aws_acm_certificate" "orders_api_cert" {
  domain = var.environment == "prod" ? "orders-api.megsparadisecakes.com" : "orders-dev-api.megsparadisecakes.com"
}
