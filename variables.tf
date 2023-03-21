variable "region" {
  default = "eu-west-2" #"us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "ami" {
  default = "ami-038d76c4d28805c09"
}




