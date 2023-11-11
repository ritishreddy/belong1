variable "aws_region" {
  default = "ap-southeast-2"
}

variable "vpc_cidr" {
  default = "172.0.0.0/16"
}

variable "subnets_cidr" {
  type    = list(string)
  default = ["172.0.0.0/24", "172.0.1.0/24"]
}

variable "private_subnets_cidr" {
  type    = list(string)
  default = ["172.0.2.0/24", "172.0.3.0/24"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-southeast-2a", "ap-southeast-2b"]
}
variable "linuxamiami" {
  default = "ami-07b5c2e394fccab6e"
}
variable "linuxami" {
  default = "ami-07b5c2e394fccab6e"
}
variable "key_name" {
  default = "ansible"
}
