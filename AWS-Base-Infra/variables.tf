variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "profile" {
  description = "AWS credentials profile you want to use"
}

variable "access_key" {
  default = "$ACCESS_KEY"
}

variable "secret_key" {
  default = "$SECRET_KEY"
}