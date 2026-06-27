output "log_group_name" {
  description = "CloudWatch log group for EKS"
  value       = aws_cloudwatch_log_group.eks.name
}