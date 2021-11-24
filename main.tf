# brach 9
variable "main_region" {
  type    = string
  default = "eu-west-2"

}
provider "aws" {
  region = var.main_region
}

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
    organization = "CloudAnalytic"

    workspaces {
      name = "ACG-Demo"
    }
  }
}


module "vpc" {
  source = "./modules/vpc"
  region = var.main_region

}
resource "aws_instance" "CWWebServer" {
  ami           = module.vpc.CW_ami_id
  subnet_id     = module.vpc.CW_pub_sub_id
  instance_type = "t2.micro"
}

