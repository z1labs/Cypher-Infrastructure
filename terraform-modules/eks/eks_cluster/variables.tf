variable "name" {
  type        = string
  description = "Name of the EKS Cluster"
}

variable "env" {
  type = string
}

variable "public_subnets" {
  description = "List of all the Public Subnets"
}

variable "private_subnets" {
  description = "List of all the Private Subnets"
}
