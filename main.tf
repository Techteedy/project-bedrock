# Random passwords for databases
resource "random_password" "mysql" {
  length           = 16
  special          = true
  override_special = "!#$%^&*"
}

resource "random_password" "postgres" {
  length           = 16
  special          = true
  override_special = "!#$%^&*"
}

# Store MySQL credentials in Secrets Manager
resource "aws_secretsmanager_secret" "mysql" {
  name                    = "project-bedrock/mysql-credentials"
  recovery_window_in_days = 0

  tags = {
    Name = "project-bedrock-mysql-secret"
  }
}

resource "aws_secretsmanager_secret_version" "mysql" {
  secret_id = aws_secretsmanager_secret.mysql.id
  secret_string = jsonencode({
    username = "admin"
    password = random_password.mysql.result
    dbname   = "retaildb"
  })
}

# Store PostgreSQL credentials in Secrets Manager
resource "aws_secretsmanager_secret" "postgres" {
  name                    = "project-bedrock/postgres-credentials"
  recovery_window_in_days = 0

  tags = {
    Name = "project-bedrock-postgres-secret"
  }
}

resource "aws_secretsmanager_secret_version" "postgres" {
  secret_id = aws_secretsmanager_secret.postgres.id
  secret_string = jsonencode({
    username = "dbadmin"
    password = random_password.postgres.result
    dbname   = "retaildb"
  })
}

# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "project-bedrock-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "project-bedrock-db-subnet-group"
  }
}

# Security Group for RDS
resource "aws_security_group" "rds" {
  name        = "project-bedrock-rds-sg"
  description = "Security group for RDS instances"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL from EKS nodes"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  ingress {
    description     = "PostgreSQL from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [var.eks_node_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project-bedrock-rds-sg"
  }
}

# MySQL RDS Instance
resource "aws_db_instance" "mysql" {
  identifier        = "project-bedrock-mysql"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retaildb"
  username = "admin"
  password = random_password.mysql.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  multi_az            = false

  tags = {
    Name = "project-bedrock-mysql"
  }
}

# PostgreSQL RDS Instance
resource "aws_db_instance" "postgres" {
  identifier        = "project-bedrock-postgres"
  engine            = "postgres"
  engine_version    = "15"
  instance_class    = "db.t3.micro"
  allocated_storage = 20

  db_name  = "retaildb"
  username = "dbadmin"
  password = random_password.postgres.result

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  skip_final_snapshot = true
  multi_az            = false

  tags = {
    Name = "project-bedrock-postgres"
  }
}