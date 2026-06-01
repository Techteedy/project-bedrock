terraform {
  backend "s3" {
    bucket  = "project-bedrock-tfstate-769369612419"
    key     = "project-bedrock/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}