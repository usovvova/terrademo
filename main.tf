terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.26.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.0.1"
    }
  }
  required_version = "~> 1.0"

  backend "remote" {
    organization = "LUMEN-LAB"

    workspaces {
      name = "lab-github-actions"
    }
  }
}


provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "web" {
  ami                          = "ami-04505e74c0741db8d"
  instance_type                = "t2.micro"
  key_name                     = "ctl-lab-paul-keypair"
  subnet_id                    = "subnet-09feeeb8979775546" # ctl-labpaul-sn-e1a-pub vpc-024b32e1dd87fb170 | ctl-lab-paul-vpc
  security_groups              = ["sg-0cd605765f7479130", "sg-0f89ecfb2b8df28a5"]
  tags = {
    Name              = "paul-baremetal_03",
    CreatedFor            = "Paul Schweiss",
    Environment           = "ctl-lab",
    "Operating System"    = "Linux",
    "Project Name"        = "Terraform Cloud GitHub Actions",
    "Automation Platform" = "Terraform"
  }
  
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
}



output "web-address" {
  value = "${aws_instance.web.public_dns}:8080"
}























