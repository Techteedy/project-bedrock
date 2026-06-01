# Assets S3 Bucket
resource "aws_s3_bucket" "assets" {
  bucket = "bedrock-assets-${var.student_id}"

  tags = {
    Name = "bedrock-assets-${var.student_id}"
  }
}

# Block all public access
resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

# IAM Role for Lambda
resource "aws_iam_role" "lambda" {
  name = "bedrock-asset-processor-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda.name
}

# Lambda function code (inline zip)
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/../../../lambda/handler.py"
  output_path = "${path.module}/lambda_function.zip"
}

# Lambda Function
resource "aws_lambda_function" "asset_processor" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "bedrock-asset-processor"
  role             = aws_iam_role.lambda.arn
  handler          = "handler.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  tags = {
    Name = "bedrock-asset-processor"
  }
}

# Allow S3 to invoke Lambda
resource "aws_lambda_permission" "s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.asset_processor.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.assets.arn
}

# S3 Event Notification to trigger Lambda on upload
resource "aws_s3_bucket_notification" "assets" {
  bucket = aws_s3_bucket.assets.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.asset_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.s3_invoke]
}