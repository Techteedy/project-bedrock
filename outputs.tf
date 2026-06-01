output "mysql_endpoint" {
  description = "MySQL RDS endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "postgres_endpoint" {
  description = "PostgreSQL RDS endpoint"
  value       = aws_db_instance.postgres.endpoint
}

output "mysql_secret_arn" {
  description = "ARN of MySQL secret in Secrets Manager"
  value       = aws_secretsmanager_secret.mysql.arn
}

output "postgres_secret_arn" {
  description = "ARN of PostgreSQL secret in Secrets Manager"
  value       = aws_secretsmanager_secret.postgres.arn
}