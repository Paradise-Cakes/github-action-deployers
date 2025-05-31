data "aws_iam_role" "desserts_api_role" {
  name = "desserts-api-role"
}

data "aws_iam_policy" "desserts_api_policy" {
  name = "desserts-api-policy"
}

data "aws_iam_policy" "datadog_kms_policy" {
  name = "DatadogKMSDecrypt"
}

data "aws_iam_role" "orders_api_role" {
  name = "orders-api-role"
}

data "aws_iam_policy" "orders_api_policy" {
  name = "orders-api-policy"
}
