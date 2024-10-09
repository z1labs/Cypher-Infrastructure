
variable "name" {
  default = "cypher_project"
}

variable "region" {
  default = "us-east-2"
}

// VPC

variable "availability_zones" {
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
  # default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}

variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

#EKS

variable "ng_enabled" {
  default = 1
}

variable "ng_instance_types" {

  default = {
    prod = ["t3.medium","t3a.medium"]
    prod = ["t3.medium","t3a.medium"]

  }
}




variable "ng_capacity_types" {

  default = {
    dev  = "SPOT"
    prod = "SPOT"
  }
}

variable "ng_disk_size" {
  default = {
    dev  = 50
    prod = 50
  }
}



variable "ng_desired_nodes_default" {
  default = {
    dev  = 1
    prod = 1
  }
}

variable "ng_max_nodes_default" {
  default = {
    dev  = 1
    prod = 1
  }
}

variable "ng_min_nodes_default" {
  default = {
    dev  = 1
    prod = 1
  }
}


variable "aws_subnets_public" {
  default = [
    "subnet-00aea80117e81af9b",
    "subnet-03bf5b1becf15ce93",
    "subnet-0f400ffeb1a6ec325",
  ]
}


variable "aws_subnets_private" {
  default = [
    "subnet-00e06e170270d92cc",
    "subnet-00d87d70ba733406c",
    "subnet-0c7936628f09d57aa",
  ]
}

variable "vpc_id" {
  default = "vpc-0433b4d84e3028912"
}

variable "security_group_id" {
  default = {
    dev = ["sg-0db7bb1d2ce24fb64"]
    prod = ["sg-0db7bb1d2ce24fb64"]
  }
}


# variable "cluster_primary_security_group_id" {
#   default = {
#     dev = "sg-0a08d588b29a39541"
#     prod = "sg-0a08d588b29a39541"
#   }
# }

