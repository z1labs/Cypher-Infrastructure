provider "aws" {
  region = var.region
}

resource "aws_security_group" "ec2_sg" {
  name        = "${var.project_name}-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}



resource "aws_instance" "ec2_instance" {
  count                  = var.instance_count
  ami                    = data.aws_ami.ubuntu.id 
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]  
  key_name               = var.key_name
  subnet_id              = var.subnet_id
  associate_public_ip_address = true

  root_block_device {
    volume_type           = var.root_volume_type   # Tipo de volume, como gp3 ou io2
    volume_size           = var.root_volume_size   # Tamanho do volume em GB
    delete_on_termination = true                  # Deleta o volume ao terminar a instância
    encrypted             = true                  # Criptografa o volume para segurança
  }

  tags = {
    Name = "${var.project_name}-ec2-${count.index}"
  }
}
