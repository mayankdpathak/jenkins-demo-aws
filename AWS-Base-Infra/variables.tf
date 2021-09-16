variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "profile" {
  default = "~/.aws/config"
}

variable "ACCESS_KEY" {
  description = "access key for subaccount"
}

variable "SECRET_KEY" {
  description = "secret key for subaccount"