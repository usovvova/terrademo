/*variable "region" {
    #type = string
    default = "eu-west-2"
}*/
variable "region" {
  type    = string
  default = "eu-west-2"
}
variable "vpc_cidr" {
    type = list
    default = ["10.0.0.0/16"]
}
variable "sub_cidr_public" {
     type = list
     default = ["10.0.1.0/24"]  
}