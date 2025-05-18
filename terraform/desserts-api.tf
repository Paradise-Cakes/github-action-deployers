resource "aws_iam_role" "desserts_api_tf_deployer_role" {
  name = "desserts-api-tf-deployer-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "desserts_api_tf_deployer_policy" {
  name        = "desserts-api-tf-deployer-policy-${var.environment}"
  description = "Policy to manage Terraform deployer for desserts API"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket",
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = [
          data.aws_s3_bucket.dessert_images_bucket.arn,
          "${data.aws_s3_bucket.dessert_images_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "desserts_api_tf_deployer_attachment" {
  policy_arn = aws_iam_policy.desserts_api_tf_deployer_policy.arn
  role       = aws_iam_role.desserts_api_tf_deployer_role.name
}
