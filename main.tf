provider "aws" {
  region     = "eu-central-1"
  # access_key = "AKIAQRRPJGQ5V6ACZSGU"
  # secret_key = "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"
}

variable "cidr_blocks" {
  description = "cidr blocks"
  # type  = list(string)
  type = list(object({
    cidr_block = string
    name       = string
  }))
}

variable "vpc_cidr_block" {
  description = "vpc/subnet cidr blocks and name tags for vpc/subnet "
  default     = "10.0.0.0/16"
  type        = string
}

resource "aws_vpc" "development-vpc" {
  # cidr_block = var.cidr_blocks[0]   //this is used to access variable from a list of strings
  cidr_block = var.cidr_blocks[0].cidr_block //this is used to access variable from a list of objects


  tags = {
    # Name : "development"   
    Name = var.cidr_blocks[0].name //this is used to access variable from a list of objects
  }
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  # cidr_block        = var.cidr_blocks[1]
  cidr_block        = var.cidr_blocks[1].cidr_block
  availability_zone = "eu-central-1a"
  tags = {
    # Name : "subnet-1-dev"
    Name = var.cidr_blocks[1].name
  }
}

data "aws_vpc" "existing_vpc" {
  default = true
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id            = data.aws_vpc.existing_vpc.id
  cidr_block        = "172.31.48.0/20"
  availability_zone = "eu-central-1a"
  tags = {
    Name : "subnet-2-default"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.development-vpc.id
}

output "dev-vpc-arn" {
  value = aws_vpc.development-vpc.arn
}

output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}
