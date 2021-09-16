variable "TF_VAR_region" {
  default = "ap-south-1"
}

variable "TF_VAR_availability_zone" {
  default = "ap-south-1a"
}

variable "TF_VAR_profile" {
  default = "~/.aws/config"
}

variable "TF_VAR_aws_access_key" {
  description = "access key for subaccount"
  default = "AKIA3DJPOB2JCLXF7CPC"
}

variable "TF_VAR_aws_secret_key" {
  description = "secret key for subaccount"
  default = "rABRcpfuBSL3E96CjJD6O7ce2n8tcKNzu13LWnWg"
}