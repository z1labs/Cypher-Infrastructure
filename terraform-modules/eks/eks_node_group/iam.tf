resource "aws_iam_role" "eks_nodes" {
  name = "eks-node-group_${var.name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes.name
}

resource "aws_iam_policy" "container_exec_policy" {
  name        = "AmazonEKSContainerExecutionPolicy_${var.name}"
  description = "Policy for Containers"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:PutLogEvents",
            "Resource": "arn:aws:logs:*:*:log-group:/aws/eks/ray-*:log-stream:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:*Object",
                "s3:ListBucket",
                "ses:SendRawEmail",
                "sqs:SendMessage",
                "logs:CreateLogStream",
                "logs:DescribeLogStreams",
                "logs:CreateLogGroup",
                "sts:AssumeRoleWithWebIdentity"
            ],
            "Resource": [
                "arn:aws:s3:::ray-assets-*",
                "arn:aws:ses:*:*:identity/ray.co",
                "arn:aws:sqs:*:*:ray-pdf-service-merge-queue*",
                "arn:aws:logs:*:*:log-group:/aws/eks/ray-*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AmazonEKSContainerExecutionRolePolicy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = aws_iam_policy.container_exec_policy.arn
}
