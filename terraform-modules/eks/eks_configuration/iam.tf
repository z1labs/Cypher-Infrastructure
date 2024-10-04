data "aws_iam_policy_document" "ekspod_sts_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:default:ekspod"]
    }

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.eks_oidc_url, "https://", "")}"]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "ekspod" {
  assume_role_policy = data.aws_iam_policy_document.ekspod_sts_policy.json
  name               = "AmazonEKSPodControllerRole_${var.env}"
}

data "aws_iam_policy_document" "ekspod_iam_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
      "sts:AssumeRoleWithWebIdentity"
    ]
    resources = [
      "arn:aws:s3:::*"
    ]
  }
}

resource "aws_iam_role_policy" "ekspod" {
  name_prefix = "eks-ekspod"
  role        = aws_iam_role.ekspod.name
  policy      = data.aws_iam_policy_document.ekspod_iam_policy.json
}

resource "kubernetes_service_account" "ekspod" {
  metadata {
    name      = "ekspod${var.env}"
    namespace = "default"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.ekspod.arn
    }
  }
  automount_service_account_token = true
}

resource "kubernetes_cluster_role" "ekspod" {
  metadata {
    name = "ekspod_${var.env}"
  }

  rule {
    api_groups = [""]
    resources  = ["services", "pods", "nodes", "endpoints"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["extensions", "networking.k8s.io"]
    resources  = ["ingresses"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = ["networking.istio.io"]
    resources  = ["gateways", "virtualservices"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "ekspod" {
  metadata {
    name = "ekspod${var.env}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.ekspod.metadata.0.name
  }
  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.ekspod.metadata.0.name
    namespace = kubernetes_service_account.ekspod.metadata.0.namespace
  }
}
