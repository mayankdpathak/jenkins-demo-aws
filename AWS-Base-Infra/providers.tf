provider "aws" {
  profile = "default"
  region  = "ap-south-1"
  access_key = "${var.ACCESS_KEY}"
  secret_key = "${var.SECRET_KEY}"
}