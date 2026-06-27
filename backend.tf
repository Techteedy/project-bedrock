terraform {
  backend "s3" {
    bucket  = "project-bedrock-tfstate-444068947686"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}