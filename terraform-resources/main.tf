#########################################
# EKS Cluster 
#########################################

terraform {
  backend "s3" {
    bucket = "cypher-terraform-backend"
    key    = "terraform-eks-vpc.tfstate"
    region = "us-east-2"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "tokie"
}

provider "aws" {
  region = var.region
}

provider "helm" {
  kubernetes {  
    config_path = "~/.kube/config"
    config_context = "tokie"
  }
}

module "eks_cluster" {
  source          = "../terraform-modules/eks/eks_cluster"
  name            = "${var.name}"
  env             = terraform.workspace
  public_subnets  = var.aws_subnets_public
  private_subnets = var.aws_subnets_private
}

module "eks_node_group" {
  source           = "../terraform-modules/eks/eks_node_group"
  name             = "${var.name}-${terraform.workspace}"
  env              = terraform.workspace
  count            = var.ng_enabled
  eks_cluster_name = module.eks_cluster.cluster_name
  subnet_ids       = var.aws_subnets_public
  instance_types   = lookup(var.ng_instance_types, terraform.workspace)
  capacity_type    = lookup(var.ng_capacity_types, terraform.workspace)
  disk_size        = lookup(var.ng_disk_size, terraform.workspace)
  desired_nodes    = lookup(var.ng_desired_nodes_default, terraform.workspace)
  max_nodes        = lookup(var.ng_max_nodes_default, terraform.workspace)
  min_nodes        = lookup(var.ng_min_nodes_default, terraform.workspace)
  depends_on       = [module.eks_cluster]
}

# #New Nodes with divesity of instance types
#  module "eks_managed_node_group_eu_central_1" {
#   depends_on       = [module.eks_cluster]
#   source =   "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
#   name            = "us-east-2a"
#   cluster_name    = "${var.name}-${terraform.workspace}"
#   cluster_version = "1.29"
#   subnet_ids = var.aws_subnets_private
#   cluster_primary_security_group_id = lookup(var.cluster_primary_security_group_id, terraform.workspace)
#   vpc_security_group_ids            = lookup(var.security_group_id, terraform.workspace)
#   desired_size    = lookup(var.ng_desired_nodes_default, terraform.workspace)
#   max_size        = lookup(var.ng_max_nodes_default, terraform.workspace)
#   min_size        = lookup(var.ng_min_nodes_default, terraform.workspace)
#   instance_types = lookup(var.ng_instance_types, terraform.workspace)
#   capacity_type  = "SPOT"
#   cluster_service_cidr = var.vpc_cidr 
#   # labels = {
#   #   Environment = "single-region"
#   #   GithubRepo  = "terraform-aws-eks"
#   #   GithubOrg   = "terraform-aws-modules"
#   # }
#   tags = {
#     Environment = terraform.workspace
#     Terraform   = "true"
#   }
# }  

module "eksconfig" {
  source           = "../terraform-modules/eks/eks_configuration"
  region           = var.region
  env              = terraform.workspace
  vpc_id           = var.vpc_id
  vpc_cidr         = var.vpc_cidr
  eks_cluster_name = module.eks_cluster.cluster_name
  eks_oidc_url     = module.eks_cluster.oidc_url
  depends_on       = [module.eks_node_group]
}


module "db" {
  depends_on       = [module.eks_cluster]
  source  = "terraform-aws-modules/rds/aws"
  version = "6.0.0"

  identifier = "cypher-${terraform.workspace}"

  engine               = "postgres"
  engine_version       = "14"
  family               = "postgres14" 
  major_engine_version = "14"         
  instance_class       = "db.t3.micro"

  allocated_storage     = 10    
  max_allocated_storage = 20
  db_name  = "${var.name}${terraform.workspace}"
  username = "${var.name}${terraform.workspace}"
  manage_master_user_password = true
  port     = 5432

  multi_az               = false
  create_db_subnet_group = true
  subnet_ids             = var.aws_subnets_public
  vpc_security_group_ids = lookup(var.security_group_id, terraform.workspace)
  publicly_accessible    = true

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = 1
  skip_final_snapshot     = true
  deletion_protection     = false

  performance_insights_enabled          = true
  performance_insights_retention_period = 7
  create_monitoring_role                = true
  monitoring_interval                   = 60
  monitoring_role_name                  = "monitoring-role"
  monitoring_role_use_name_prefix       = true
  monitoring_role_description           = "Description for monitoring role"

  parameters = [
    {
      name  = "autovacuum"
      value = 1
    },
    {
      name  = "client_encoding"
      value = "utf8"
    }
  ]
} 
