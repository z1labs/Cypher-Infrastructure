#########################################
# Blockchain Nodes
#########################################

terraform {
  backend "s3" {
    bucket = "cypher-terraform-backend"
    key    = "terraform-blockchain-nodes.tfstate"
    region = "us-east-2"
  }
}

provider "aws" {
  region = "us-east-2"
}


module "ec2_with_sg" {
  source           = "../terraform-modules/nodes"
  region           = "us-east-2"
  project_name     = "cypher-blockchain-nodes"
  vpc_id           = "vpc-0433b4d84e3028912"
  subnet_id        = "subnet-00aea80117e81af9b"
  ami_id           = "ami-123456"
  instance_type    = "i3.xlarge"
  key_name         = "cypher-nodes"
  instance_count   = 1
  root_volume_type = "gp3"
  root_volume_size = 1000

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["69.209.125.120/32"]
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["45.182.75.69/32"]
    }
  ]
}
