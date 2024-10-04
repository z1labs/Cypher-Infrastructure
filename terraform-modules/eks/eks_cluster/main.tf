resource "aws_eks_cluster" "eks_cluster" {
  name                      = "${var.name}-${var.env}"
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  role_arn                  = aws_iam_role.eks_cluster.arn
  version                   = "1.29"

  vpc_config {
    endpoint_private_access = true
    subnet_ids              = concat(var.private_subnets)
    # subnet_ids              = concat(var.public_subnets, var.private_subnets)
  }

  tags = {
    Name = "eks_cluster_${var.env}"
  }
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy
  ]
}
