# Provider Configuration - Ye batata hai Terraform ko kis cloud pe kaam karna hai
provider "aws" {
  region = "eu-north-1"
}

# Networking - explicitly reference the default VPC and its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group - Ye ek firewall jaisa hai, batata hai konsa traffic allow hai
resource "aws_security_group" "docker_sg" {
  name        = "docker-server-sg"
  description = "Allow SSH, HTTP and app port traffic"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access for web app"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Custom app port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-server-sg"
  }
}

# EC2 Instance - Ye actual server hai jo banega
resource "aws_instance" "docker_server" {
  ami                    = "ami-0989fb15ce71ba39e"  # Ubuntu 22.04 LTS (eu-north-1)
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer_key.key_name
  vpc_security_group_ids = [aws_security_group.docker_sg.id]
  subnet_id              = data.aws_subnets.default.ids[0]

  tags = {
    Name = "B9IS121-Docker-Server"
  }
}

# SSH Key Pair - Isse hum server mein login kar sakenge
resource "aws_key_pair" "deployer_key" {
  key_name   = "b9is121-key"
  public_key = file("${path.module}/b9is121-key.pub")
}

# Output - Terraform apply hone ke baad server ka IP address dikhayega
output "server_public_ip" {
  value = aws_instance.docker_server.public_ip
}