# 1. The Identity Provider (Tells AWS to trust GitHub)
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]

  # Standard GitHub TLS thumbprints 
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

# 2. The IAM Role for GitHub Actions
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-ci-role"

  # Trust Policy: Only allow GitHub to assume this role, and ONLY for your specific repository
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }

          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:Pratik-Kaware*/enterprise-terraform-aws*:*"
          }
        }
      }
    ]
  })
}

# 3. The Permissions (What can GitHub do once it assumes the role?)
# NOTE: For this learning project, we are granting AdministratorAccess so the pipeline can build anything.
# In a strict production environment, you would use a scoped-down least-privilege policy.
resource "aws_iam_role_policy_attachment" "github_actions_admin" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}