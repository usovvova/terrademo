variable "AWS_REGION" {
  # Variable to set default aws region
  default = "us-east-1"
}

variable "AMI_Machine" {
  type    = string
  default = "ami-01d08089481510ba2"

}

variable "PUBLIC_KEY_PATH" {
  default = "aws-key-ssh-test.pub"
}

variable "PRIVATE_KEY_PATH" {
  default = "aws-key-ssh-test"
}

variable "EC2_user" {
  default = "ubuntu"
}