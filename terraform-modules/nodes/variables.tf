variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
}

variable "project_name" {
  description = "The project name to identify resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
}

variable "key_name" {
  description = "The key pair to use for the EC2 instance"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
}


variable "root_volume_type" {
  description = "The type of the root EBS volume (e.g., gp3, io2)"
  type        = string
}

variable "root_volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
}
