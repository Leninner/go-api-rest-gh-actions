terraform {
  required_version = ">= 1.6.6"

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
}

provider "aws" {
  region = var.aws_region
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "go_api_server" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_group.id]
  key_name               = "go-api"

  tags = {
    Name = "go-api-server"
  }
}

resource "aws_security_group" "security_group" {
  vpc_id      = data.aws_vpc.default.id
  description = "Allow SSH (TCP port 22), TCP/3001 from the world and HTTP (TCP port 80) access to GO API Server"
  name        = "go-api-server-sg"

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
    from_port   = var.go-api-port
    to_port     = var.go-api-port
    protocol    = "tcp"
    cidr_blocks = var.allowed_http_cidr_blocks
    description = "Allow GO API access from the world"
  }
}
