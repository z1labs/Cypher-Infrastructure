/* IMPORTANT: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html */

resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name                                           = "${var.name}-vpc"
    "kubernetes.io/cluster/${var.name}" = "shared"
  }
}
