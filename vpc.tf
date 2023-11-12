# Provider
provider "aws" {
  region = "ap-southeast-2"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "demo_vpc"
  }
}
resource "aws_key_pair" "ssh" {
  key_name   = "DemoMachine"
  public_key = tls_private_key.ssh.public_key_openssh
}
# IGW for demo_vpc
resource "aws_internet_gateway" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_vpc_igw"
  }
}

# Subnets in demo_vpc
resource "aws_subnet" "nat_gateway" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  tags = {
    Name = "demo_vpc_nat_gateway_${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count                   = length(var.subnets_cidr)
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = false
  tags = {
    Name = "demo_vpc_private_subnet_${count.index + 1}"
  }
}

# Route table for demo_vpc
resource "aws_route_table" "nat_gateway" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.nat_gateway.id
  }
  tags = {
    Name = "demo_vpc_public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "demo_vpc_private_rt"
  }
}

# Route table and subnets association for public subnet
resource "aws_route_table_association" "nat_gateway" {
  count          = length(var.subnets_cidr)
  subnet_id      = element(aws_subnet.nat_gateway.*.id, count.index)
  route_table_id = aws_route_table.nat_gateway.id
}

# Route table and subnets association for private subnet
resource "aws_route_table_association" "private_rt_association" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}
