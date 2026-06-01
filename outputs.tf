output "carts_table_name" {
  description = "DynamoDB carts table name"
  value       = aws_dynamodb_table.carts.name
}

output "orders_table_name" {
  description = "DynamoDB orders table name"
  value       = aws_dynamodb_table.orders.name
}