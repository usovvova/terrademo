variable "main_region" {
  type    = string
  default = "eu-west-2"

}
provider "aws" {
  region = var.main_region
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

