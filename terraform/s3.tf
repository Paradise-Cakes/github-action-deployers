data "aws_s3_bucket" "dessert_images_bucket" {
  bucket = "dessert-images-bucket-${var.environment}"
}
