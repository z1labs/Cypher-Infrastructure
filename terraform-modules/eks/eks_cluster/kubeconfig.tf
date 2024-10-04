data "template_file" "kubeconfig" {
  template = file("${path.module}/templates/kubeconfig.tpl")

  vars = {
    kubeconfig_name     = aws_eks_cluster.eks_cluster.name
    clustername         = aws_eks_cluster.eks_cluster.name
    endpoint            = aws_eks_cluster.eks_cluster.endpoint
    cluster_auth_base64 = aws_eks_cluster.eks_cluster.certificate_authority[0].data
    environment         = var.env
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = pathexpand("~/.kube/${var.name}${var.env}")
}
