variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "eks_node_role_name" {
  description = "EKS node IAM role name"
  type        = string
}