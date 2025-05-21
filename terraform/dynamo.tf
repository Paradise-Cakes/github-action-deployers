data "aws_dynamodb_table" "desserts_table" {
  name = "desserts"
}

data "aws_dynamodb_table" "desserts_type_count_table" {
  name = "dessert_type_count"
}

data "aws_dynamodb_table" "prices_table" {
  name = "prices"
}

