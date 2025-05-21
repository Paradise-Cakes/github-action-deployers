data "aws_s3_bucket" "desserts_api_tf_state_bucket" {
  bucket = var.environment == "prod" ? "desserts-api-tfstate" : "desserts-dev-api-tfstate"
}

data "aws_s3_bucket" "dessert_images_bucket" {
  bucket = var.environment == "prod" ? "dessert-images-bucket-prod" : "dessert-images-bucket-dev"
}

data "aws_s3_bucket" "desserts_api_tf_state_bucket" {
  bucket = var.environment == "prod" ? "desserts-api-tfstate" : "desserts-dev-api-tfstate"
}
