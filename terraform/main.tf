terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Find the existing Default VPC
data "aws_vpc" "default" {
  default = true
}

# Find subnets inside the Default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Find the existing Default Security Group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

# Get the latest Ubuntu 24.04 LTS AMI
data "aws_ssm_parameter" "ubuntu" {
  name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
}

# Allow SSH from your IP
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  security_group_id = data.aws_security_group.default.id

  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [var.my_ip_cidr]
}

# Allow HTTP from the internet
resource "aws_security_group_rule" "allow_http" {
  type              = "ingress"
  security_group_id = data.aws_security_group.default.id

  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# Create EC2 instance
resource "aws_instance" "web_server" {
  ami           = data.aws_ssm_parameter.ubuntu.value
  instance_type = var.instance_type

  subnet_id = data.aws_subnets.default.ids[0]

  vpc_security_group_ids = [
    data.aws_security_group.default.id
  ]

  key_name = var.key_name

  associate_public_ip_address = true

  tags = {
    Name = "devops-web-server"
  }
}
