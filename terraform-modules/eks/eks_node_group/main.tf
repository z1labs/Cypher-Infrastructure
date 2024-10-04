resource "aws_eks_node_group" "node" {
  cluster_name    = var.eks_cluster_name
  node_group_name = "${var.name}-${var.env}"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.instance_types
  disk_size       = var.disk_size
  capacity_type   = var.capacity_type

  scaling_config {
    desired_size = var.desired_nodes
    max_size     = var.max_nodes
    min_size     = var.min_nodes
  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKSContainerExecutionRolePolicy
  ]
}
