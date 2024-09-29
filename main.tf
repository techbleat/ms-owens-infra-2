terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-2"
}

# creating the frontend system

resource "aws_security_group" "frontend-sg" {
  name = "ms-cleaning-service-frontend-sg"
  # ... other configuration ...

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 5173
    to_port          = 5173
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "front-end" {
  ami                    = var.frontend_ami
  instance_type          = var.frontend_instance_type
  key_name               = var.frontend_key_name
  user_data              = file("./frontend-install.sh")
  vpc_security_group_ids = [aws_security_group.frontend-sg.id]
  tags = {
    Name = "front-end"
  }
}



# creating the backend system
resource "aws_security_group" "backend-sg" {
  name = "ms-cleaning-service-backend-sg"
  # ... other configuration ...

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_instance" "backend" {
  ami                    = var.backend_ami
  instance_type          = var.backend_instance_type
  key_name               = var.backend_key_name
  #user_data              = file("./backend-install.sh")
  vpc_security_group_ids = [aws_security_group.backend-sg.id]
  tags = {
    Name = "backend"
  }
}


