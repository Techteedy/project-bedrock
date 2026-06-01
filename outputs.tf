output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "region" {
  description = "AWS region"
  value       = var.aws_region
}

output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "assets_bucket_name" {
  description = "Assets S3 bucket name"
  value       = module.s3_lambda.bucket_name
}

output "dev_user_access_key_id" {
  description = "Dev user access key ID"
  value       = module.iam.dev_access_key_id
}

output "dev_user_secret_key" {
  description = "Dev user secret access key"
  value       = module.iam.dev_secret_access_key
  sensitive   = true
}

output "dev_console_password" {
  description = "Dev user console password"
  value       = module.iam.dev_console_password
  sensitive   = true
}