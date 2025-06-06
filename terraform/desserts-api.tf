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
          "s3:*"
        ],
        Resource = [
          data.aws_s3_bucket.desserts_api_tf_state_bucket.arn,
          "${data.aws_s3_bucket.desserts_api_tf_state_bucket.arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "acm:ListCertificates",
          "acm:DescribeCertificate",
          "acm:GetCertificate",
          "acm:ListTagsForCertificate"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "apigateway:GET",
          "apigateway:PATCH",
          "apigateway:PUT",
          "apigateway:POST",
          "apigateway:DELETE",
          "apigateway:HEAD",
          "apigateway:OPTIONS",
        ],
        Resource = [
          "arn:aws:apigateway:${var.region}::/restapis/${data.aws_api_gateway_rest_api.desserts_rest_api.id}/*",
          "arn:aws:apigateway:${var.region}::/restapis/${data.aws_api_gateway_rest_api.desserts_rest_api.id}",
          "arn:aws:apigateway:${var.region}::/domainnames/${data.aws_api_gateway_domain_name.desserts_domain_name.domain_name}",
          "arn:aws:apigateway:${var.region}::/domainnames/${data.aws_api_gateway_domain_name.desserts_domain_name.domain_name}/*",
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "logs:DescribeLogGroups",
          "logs:ListTagsForResource",
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "cognito-idp:DescribeUserPool"
        ],
        Resource = [
          data.aws_cognito_user_pool.paradise_cakes_user_pool.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:DescribeTable",
          "dynamodb:DescribeContinuousBackups",
          "dynamodb:DescribeTimeToLive",
          "dynamodb:ListTagsOfResource",
        ],
        Resource = [
          data.aws_dynamodb_table.desserts_table.arn,
          data.aws_dynamodb_table.desserts_type_count_table.arn,
          data.aws_dynamodb_table.prices_table.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:DescribeRepositories",
          "ecr:DescribeImages",
          "ecr:ListTagsForResource",
        ],
        Resource = [
          data.aws_ecr_repository.desserts_api_repository.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:DescribeImages",
          "ecr:ListImages",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:TagResource",
          "ecr:UntagResource",
          "ecr:CreateRepository",
          "ecr:DeleteRepository",
          "ecr:DeleteRepositoryPolicy",
          "ecr:PutLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy",
          "ecr:PutImageScanningConfiguration",
          "ecr:PutImageTagMutability",
          "ecr:StartImageScan",
          "ecr:StopImageScan",
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:ListRolePolicies",
          "iam:GetPolicyVersion",
          "iam:ListAttachedRolePolicies"
        ],
        Resource = [
          data.aws_iam_role.desserts_api_role.arn,
          data.aws_iam_policy.desserts_api_policy.arn,
          data.aws_iam_policy.datadog_kms_policy.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "route53:ListHostedZones",
          "route53:GetHostedZone",
          "route53:ListTagsForResource"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:*",
        ],
        Resource = [
          data.aws_s3_bucket.dessert_images_bucket.arn,
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "lambda:*",
        ],
        Resource = [
          data.aws_lambda_function.desserts_api.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "desserts_api_tf_deployer_attachment" {
  policy_arn = aws_iam_policy.desserts_api_tf_deployer_policy.arn
  role       = aws_iam_role.desserts_api_tf_deployer_role.name
}
