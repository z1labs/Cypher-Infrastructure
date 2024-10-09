variable "region" {
  description = "The AWS region to deploy the resources"
  type        = string
  default     = "us-east-2"
}

variable "project_name" {
  description = "The project name to identify resources"
  type        = string
  default     = "cypher-blockchain-nodes"
}

variable "vpc_id" {
  description = "The ID of the VPC where resources will be created"
  type        = string
  default = ""
}

variable "subnet_id" {
  description = "The ID of the subnet where the EC2 instance will be launched"
  type        = string
  default = ""
}

variable "ami_id" {
  description = "The AMI ID to use for the EC2 instance"
  type        = string
  default = ""
}

variable "instance_type" {
  description = "The type of EC2 instance to create"
  type        = string
  default     = "i3.xlarge"
}

variable "key_name" {
  description = "The key pair to use for the EC2 instance"
  type        = string
  default = ""
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}

variable "ingress_rules" {
  description = "List of ingress rules for the security group"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
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

variable "root_volume_type" {
  description = "The type of the root EBS volume (e.g., gp3, io2)"
  type        = string
  default     = "gp3"
}

variable "root_volume_size" {
  description = "The size of the root EBS volume in GB"
  type        = number
  default     = 1000
}
