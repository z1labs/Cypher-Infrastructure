variable "name" {
  type = string
}

variable "region" {
  type = string
}


variable "cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "availability_zones" {
  type = list(string)
}

variable "vpc_id" {
  default = "vpc-00bdc5bb689dab54b"
}

# variable "subnets_public" {
#   type = list(string)
# }

# variable "subnets_private" {
#   type = list(string)
# }