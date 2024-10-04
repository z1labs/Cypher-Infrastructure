data "http" "iam_policy_efs" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.3.2/docs/iam-policy-example.json"
  request_headers = {
    Accept = "application/json"
  }
}

resource "aws_iam_policy" "AmazonEKS_EFS_CSI_Driver_Policy" {
  name = "AmazonEKS_EFS_CSI_Driver_Policy_${var.env}"
  policy = data.http.iam_policy_efs.body
}


data "aws_iam_policy_document" "trust_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

     condition {
       test     = "StringEquals"
       variable = "${replace(var.eks_oidc_url, "https://", "")}:sub"
       values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
     }

     principals {
       identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${replace(var.eks_oidc_url, "https://", "")}"]
       type        = "Federated"
     }
   }
 }

resource "aws_iam_role" "efs_csi" {
  assume_role_policy = data.aws_iam_policy_document.trust_policy.json
  name               = "AmazonEKS_EFS_CSI_DriverRole_${var.env}"
}

resource "aws_iam_role_policy_attachment" "EFS_IAMPolicy" {
  policy_arn = aws_iam_policy.AmazonEKS_EFS_CSI_Driver_Policy.arn
  role       = aws_iam_role.efs_csi.name
}

resource "kubernetes_service_account" "efs_csi_controller_sa" {
  automount_service_account_token = true
  metadata {
    name      = "efs-csi-controller-sa-${var.env}"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.efs_csi.arn

    }
    labels = {
      "app.kubernetes.io/name"       = "aws-efs-csi-driver"
      "app.kubernetes.io/managed-by" = "Helm"
    }
  }
}
