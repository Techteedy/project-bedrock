# IAM User for developer read-only access
resource "aws_iam_user" "dev_view" {
  name = "bedrock-dev-view"

  tags = {
    Name = "bedrock-dev-view"
  }
}

# Attach AWS ReadOnlyAccess managed policy
resource "aws_iam_user_policy_attachment" "readonly" {
  user       = aws_iam_user.dev_view.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

# Allow dev user to upload to assets bucket
resource "aws_iam_user_policy" "s3_putobject" {
  name = "bedrock-dev-s3-putobject"
  user = aws_iam_user.dev_view.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "s3:PutObject"
        Resource = "arn:aws:s3:::bedrock-assets-${var.student_id}/*"
      }
    ]
  })
}

# Console login profile (password for AWS console)
resource "aws_iam_user_login_profile" "dev_view" {
  user                    = aws_iam_user.dev_view.name
  password_reset_required = false
}

# Access key for CLI/API access
resource "aws_iam_access_key" "dev_view" {
  user = aws_iam_user.dev_view.name
}