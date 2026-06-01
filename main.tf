# DynamoDB table for the retail app (carts/sessions)
resource "aws_dynamodb_table" "carts" {
  name         = "project-bedrock-carts"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "customerId"

  attribute {
    name = "customerId"
    type = "S"
  }

  tags = {
    Name = "project-bedrock-carts"
  }
}

# DynamoDB table for orders
resource "aws_dynamodb_table" "orders" {
  name         = "project-bedrock-orders"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }

  tags = {
    Name = "project-bedrock-orders"
  }
}