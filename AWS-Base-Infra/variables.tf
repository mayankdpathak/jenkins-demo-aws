variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "profile" {
  default = "~/.aws/config"
}

variable "access_key" {
  aws_access_key_id = "~/.aws/credentials"
}

variable "secret_key" {
  aws_secret_access_key = "~/.aws/credentials"
}