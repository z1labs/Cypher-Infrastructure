
variable "name" {
  default = "cypher"
}

variable "region" {
  default = "us-east-2"
}


variable "availability_zones" {
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}


variable "vpc_cidr" {
  default = "10.20.0.0/16"
}

variable "private_subnets" {
  default = [
    "10.20.0.0/24",
    "10.20.1.0/24",
    "10.20.2.0/24",
  ]
}

variable "public_subnets" {
  default = [
    "10.20.6.0/24",
    "10.20.7.0/24",
    "10.20.8.0/24",
  ]
}