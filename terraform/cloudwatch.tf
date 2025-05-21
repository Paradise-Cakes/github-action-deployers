data "aws_cloudwatch_log_group" "desserts_api_log_group" {
  name = "/aws/lambda/desserts-api-us-east-1"
}
