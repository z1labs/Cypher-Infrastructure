variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "eks_cluster_name" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "instance_types" {
  type = list(string)
}

variable "capacity_type" {
  type = string
}

variable "disk_size" {
  type = number
}

variable "desired_nodes" {
  type = number
}

variable "max_nodes" {
  type = number
}

variable "min_nodes" {
  type = number
}

