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
  description = "access key for subaccount"
}

variable "secret_key" {
  description = "secret key for subaccount"