provider "aws" {
  region = "eu-central-1"
}

# variable "cidr_blocks" {
#   description = "cidr blocks"
#   # type  = list(string)
#   type = list(object({
#     cidr_block = string
#     name       = string
#   }))
# }

# variable "vpc_cidr_block" {
#   description = "vpc/subnet cidr blocks and name tags for vpc/subnet "
#   default     = "10.0.0.0/16"
#   type        = string
# }

variable "vpc_cidr_block" {}
variable "subnet_cidr_block" {}
variable "avail_zone" {}
variable "env_prefix" {}


resource "aws_vpc" "myapp-vpc" {
  # cidr_block = var.cidr_blocks[0]   //this is used to access variable from a list of strings
  # cidr_block = var.cidr_blocks[0].cidr_block //this is used to access variable from a list of objects
  cidr_block = var.vpc_cidr_block
  tags = {
    # Name : "development"   
    # Name = var.cidr_blocks[0].name //this is used to access variable from a list of objects
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "myapp-subnet-1" {
  vpc_id = aws_vpc.myapp-vpc.id
  # cidr_block        = var.cidr_blocks[1]
  # cidr_block        = var.cidr_blocks[1].cidr_block
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    # Name : "subnet-1-dev"
    # Name = var.cidr_blocks[1].name
    Name = "${var.env_prefix}-subnet-1"
  }
}


resource "aws_internet_gateway" "myapp-igw" {
  vpc_id = aws_vpc.myapp-vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

# resource "aws_route_table" "myapp-route-table" {
#   vpc_id = aws_vpc.myapp-vpc.id
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.myapp-igw.id
#   }
#   tags = {
#     Name = "${var.env_prefix}-rtb"
#   }
# }

resource "aws_default_route_table" "main-rtb" {
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.myapp-igw.id
  }
  tags = {
    Name = "${var.env_prefix}-main-rtb"
  }
}

# resource "aws_route_table_association" "a-rtb-subnet" {
#   subnet_id      = aws_subnet.myapp-subnet-1.id
#   route_table_id = aws_route_table.myapp-route-table.id
# }

# data "aws_vpc" "existing_vpc" {
#   default = true
# }

resource "aws_default_security_group" "default-sg" {
  # name   = "myapp-sg"
  vpc_id = aws_vpc.myapp-vpc.id

  ingress {
    from_port  = 22
    to_port    = 22
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port  = 8080
    to_port    = 8080
    protocol   = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-default-sg"
  }
}

output "dev-vpc-id" {
  value = aws_vpc.myapp-vpc.id
}

output "dev-vpc-arn" {
  value = aws_vpc.myapp-vpc.arn
}

output "dev-subnet-id" {
  value = aws_subnet.myapp-subnet-1.id
}
