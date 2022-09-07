terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.29.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.4.2"
    }
  }
  required_version = "~> 1.0"

  backend "remote" {
    organization = "CloudMan"
    workspaces {
      name = "demo-github-actions"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}



resource "random_pet" "sg" {}

resource "aws_instance" "web" {
  ami                    = "ami-05fa00d4c63e32376"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["aws_security_group.web-sg.id"]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}

resource "aws_security_group" "web-sg" {
  name = "${random_pet.sg.id}-sg"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}
