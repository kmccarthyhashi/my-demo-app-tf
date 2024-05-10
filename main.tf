terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "0.23.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.42.0"
    }
  }
  required_version = ">= 0.14.5"
}

provider "aws" {
  region = "us-east-2"
}

locals {
  tags = {
    Name = "My Demo App - ${var.environment_tag}"
    Environment = var.environment_tag
    ManagedBy = "terraform"
  }
}

module "vpc" {
  source  = "app.terraform.io/KELLY-training/vpc/aws"
  version = "1.0.0"

  cidr_vpc = "10.1.0.0/16"
  cidr_subnet = "10.1.0.0/24"
  tags = local.tags
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ubuntu" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = module.vpc.subnet_id
  vpc_security_group_ids      = [module.vpc.vpc_security_group_id]
  associate_public_ip_address = true

  tags = local.tags
}
