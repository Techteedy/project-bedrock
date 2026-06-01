module "vpc" {
  source   = "./modules/vpc"
  vpc_name = var.vpc_name
  region   = var.aws_region
}

module "eks" {
  source       = "./modules/eks"
  cluster_name = var.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
}

module "rds" {
  source         = "./modules/rds"
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnet_ids
  eks_node_sg_id = module.eks.node_security_group_id
}

module "dynamodb" {
  source = "./modules/dynamodb"
}

module "s3_lambda" {
  source     = "./modules/s3-lambda"
  student_id = var.student_id
}

module "iam" {
  source     = "./modules/iam"
  student_id = var.student_id
}

module "cloudwatch" {
  source             = "./modules/cloudwatch"
  cluster_name       = var.cluster_name
  region             = var.aws_region
  eks_node_role_name = "${var.cluster_name}-node-role"
}