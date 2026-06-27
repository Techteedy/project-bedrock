# CloudWatch Log Group for EKS control plane
resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7

  tags = {
    Name = "${var.cluster_name}-log-group"
  }
}

# CloudWatch Log Group for application containers
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/eks/${var.cluster_name}/retail-app"
  retention_in_days = 7

  tags = {
    Name = "${var.cluster_name}-app-log-group"
  }
}

# IAM Policy for CloudWatch Observability addon
resource "aws_iam_role_policy_attachment" "cloudwatch_observability" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = var.eks_node_role_name
}

# EKS CloudWatch Observability Addon
resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name             = var.cluster_name
  addon_name               = "amazon-cloudwatch-observability"
  resolve_conflicts_on_create = "OVERWRITE"

  tags = {
    Name = "${var.cluster_name}-cloudwatch-addon"
  }
}