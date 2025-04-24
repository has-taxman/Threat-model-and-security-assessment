# # OIDC Provider for GitHub (only create once per account)
# resource "aws_iam_openid_connect_provider" "github" {
#   url             = "https://token.actions.githubusercontent.com"
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"] # GitHub's cert
# }

# IAM Role for GitHub Actions (OIDC)
resource "aws_iam_role" "github_oidc" {
  name = "GitHubOIDCRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = "arn:aws:iam::<your-account-id>:oidc-provider/token.actions.githubusercontent.com"
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = [
              "repo:has-taxman/Threat-model-and-security-assessment:ref:refs/heads/*",
              "repo:has-taxman/Threat-model-and-security-assessment:environment:dev"
            ]
          }
        }
      }
    ]
  })
}

# Attach permissions - use fine-grained policies in prod!
resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.github_oidc.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}
