variable "region" {
  default = "ap-south-1"
}

variable "availability_zone" {
  default = "ap-south-1a"
}

variable "profile" {
  default = "~/.aws/config"
}

variable "aws_access_key" {
  description = "access key for subaccount"
  default = "AKIA3DJPOB2JCLXF7CPC"
}

variable "aws_secret_key" {
  description = "secret key for subaccount"
  default = "rABRcpfuBSL3E96CjJD6O7ce2n8tcKNzu13LWnWg"
}