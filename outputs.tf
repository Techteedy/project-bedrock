output "bucket_name" {
  description = "Assets S3 bucket name"
  value       = aws_s3_bucket.assets.bucket
}

output "lambda_function_name" {
  description = "Lambda function name"
  value       = aws_lambda_function.asset_processor.function_name
}