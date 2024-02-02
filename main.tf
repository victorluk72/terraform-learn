provider "aws" {
  region  = "us-east-1"
}

# Variables block
variable "subnet_cidr_block" {
  description = "subnet cidr block"
  default = "10.0.00.0/24"
}


# 1-Create custom VPC
resource "aws_vpc" "dev-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "dev-vpc-name"
    vpc_env = "dev"
  }
}

# 2-Create custom subnet for VPC from step 1
resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.dev-vpc.id
  cidr_block = var.subnet_cidr_block
  availability_zone = "us-east-1a"
    tags = {
    Name = "dev-subnet1-name"
  }
}

# data is to fetch information about existing resourse
  
# 3-Find default vpc and add subnet to it ------
data "aws_vpc" "existing_default_vpc" {
 default = true
}

# 4-Add subnet to defaul vpc  ------
resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_default_vpc.id
  cidr_block = "172.31.96.0/20"
  availability_zone = "us-east-1a"
}

# 5-Create output with ID of each created component
output "dev-vpc-id" {
  value = aws_vpc.dev-vpc.id
}
 
output "dev-subnet-id" {
  value = aws_subnet.dev-subnet-1.id
}