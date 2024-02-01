terraform {
  cloud {
    organization = "leninner"

    workspaces {
      name = "go-api-terraform-github-actions"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.33.0"
    }
  }

  required_version = ">= 1.6.6"
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "go_api_server" {
  ami = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [ aws_security_group.security_group.id ]
  key_name = "go-api"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y golang
              EOF

  tags = {
    Name = "go-api-server"
  }
}

resource "aws_security_group" "security_group" {
  vpc_id      = data.aws_vpc.default.id
  description = "Allow SSH (TCP port 22) and HTTP (TCP port 80) in"
  name = "go-api-server-sg"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
    description = "Allow SSH access from the world"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr_blocks
    description = "Allow HTTP access from the world"
  }

  ingress {
    from_port = 3001
    to_port = 3001
    protocol = "tcp"
    cidr_blocks = var.allowed_http_cidr_blocks
    description = "Allow GO API access from the world"
  }
}