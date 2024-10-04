#########################################
# VPC - Network
#########################################

terraform {
  backend "s3" {
    bucket = "cypher-terraform-backend"
    key    = "terraform-vpc.tfstate"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      version = "~> 3.50.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "../terraform-modules/vpc"
  region             = var.region
  name               = "${var.name}"
  cidr               = var.vpc_cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
}