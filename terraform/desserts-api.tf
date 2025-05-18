data "aws_iam_policy_document" "desserts_api_tf_deployer_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Paradise-Cakes/*"]
    }
  }
}


resource "aws_iam_role" "desserts_api_tf_deployer_role" {
  name               = "desserts-api-tf-deployer-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.desserts_api_tf_deployer_assume_role_policy.json
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
          "s3:GetObject"
        ],
        Resource = [
          data.aws_s3_bucket.desserts_api_tf_state_bucket.arn,
          "${data.aws_s3_bucket.desserts_api_tf_state_bucket.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "desserts_api_tf_deployer_attachment" {
  policy_arn = aws_iam_policy.desserts_api_tf_deployer_policy.arn
  role       = aws_iam_role.desserts_api_tf_deployer_role.name
}
