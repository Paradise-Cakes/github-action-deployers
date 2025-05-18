data "aws_acm_certificate" "desserts_api_cert" {
  domain = vari.environment == "prod" ? "desserts-api.megsparadisecakes.com" : "desserts-dev-api.megsparadisecakes.com"
}
