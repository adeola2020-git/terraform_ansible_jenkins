variable "region" {
  default = "us-east-1" #"us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "ami" {
  default = "ami-0557a15b87f6559cf"
}




