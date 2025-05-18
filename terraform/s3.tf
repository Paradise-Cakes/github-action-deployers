data "aws_s3_bucket" "desserts_api_tf_state_bucket" {
  bucket = var.environment == "prod" ? "desserts-api-tfstate" : "desserts-dev-api-tfstate"
}
