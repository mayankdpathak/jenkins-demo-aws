provider "aws" {
  profile = "default"
  region  = "ap-south-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_vpc" "My-VPC-TF" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "My-VPC-Subnet" {
  availability_zone = var.availability_zone
  vpc_id            = aws_vpc.My-VPC-TF.id
  cidr_block        = "10.0.1.0/24"


}

resource "aws_security_group" "vpc-sg-tf" {
  name        = "vpc-sg-tf"
  description = "Allow incoming HTTP connections."
  vpc_id      = aws_vpc.My-VPC-TF.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_instance" "myinstance-web1" {
  availability_zone = var.availability_zone
  ami               = "ami-00bf4ae5a7909786c"
#  key_name          = var.aws_key_name
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.My-VPC-Subnet.id

}

resource "aws_instance" "myinstance-web2" {
  availability_zone = var.availability_zone
  ami               = "ami-00bf4ae5a7909786c"
#  key_name          = var.aws_key_name
  instance_type     = "t2.micro"
  subnet_id         = aws_subnet.My-VPC-Subnet.id

}