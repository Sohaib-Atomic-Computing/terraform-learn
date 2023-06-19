provider "aws" {
  region = "eu-central-1"
}


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

module "myapp-subnet" {
  source                 = "./modules/subnet"
  subnet_cidr_block      = var.subnet_cidr_block
  avail_zone             = var.avail_zone
  env_prefix             = var.env_prefix
  vpc_id                 = aws_vpc.myapp-vpc.id
  default_route_table_id = aws_vpc.myapp-vpc.default_route_table_id
}

module "myapp-server" {
  source        = "./modules/webserver"
  vpc_id        = aws_vpc.myapp-vpc.id
  env_prefix    = var.env_prefix
  instance_type = var.instance_type
  subnet_id     = module.myapp-subnet.subnet.id
  avail_zone    = var.avail_zone
}




