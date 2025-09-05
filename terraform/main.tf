terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws   = ">=3.54.0"
    local = ">=2.1.0"
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "new-vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name        = "${var.prefix}-vpc"
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnets" {
  count                   = 2
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.new-vpc.id
  cidr_block              = "10.0.${count.index}.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.prefix}-subnet-${count.index}"
    Environment = var.environment
  }
}

# Create an internet gateway to give our subnet access to the outside world
resource "aws_internet_gateway" "new-igw" {
  vpc_id = aws_vpc.new-vpc.id
  tags = {
    Name        = "${var.prefix}-igw"
    Environment = var.environment
  }
}

// Everything here will have access to the internet
resource "aws_route_table" "new-rtb" {
  vpc_id = aws_vpc.new-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.new-igw.id
  }
  tags = {
    Name        = "${var.prefix}-rtb"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "new-rtb-association" {
  count          = 2
  route_table_id = aws_route_table.new-rtb.id
  subnet_id      = aws_subnet.subnets.*.id[count.index]
}


