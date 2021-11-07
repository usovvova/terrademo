
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}


# Configure the AWS Provider
provider "aws" {
  region = var.region
}

resource "aws_vpc" "CW_vpc"  {
    cidr_block = "10.0.0.0/16" 
    tags = {
        "Name"="CW_vpc_name"
    }
}
resource "aws_subnet" "CW_sub_public" {
    vpc_id = aws_vpc.CW_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
      "Name" = "CW_sub_public_name"
    }
}
data "aws_ssm_parameter" "CW_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}
