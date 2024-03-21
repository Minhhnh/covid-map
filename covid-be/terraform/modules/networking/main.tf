provider "aws" {
  region = var.region
}
resource "aws_vpc" "covid_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "Covid Demo VPC"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "covid_igw" {
  vpc_id = aws_vpc.covid_vpc.id
  tags = {
    Name = "Covid Demo IGW"
  }
}

# Public subnet
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.covid_vpc.id
  cidr_block        = var.public_subnet_ips[0]
  availability_zone = var.availability_zone_1
  tags = {
    Name = "Covid Demo Public Subnet 1"
  }
}
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.covid_vpc.id
  cidr_block        = var.public_subnet_ips[1]
  availability_zone = var.availability_zone_2
  tags = {
    Name = "Covid Demo Public Subnet 2"
  }
}
# Private subnet
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.covid_vpc.id
  cidr_block        = var.private_subnet_ips[0]
  availability_zone = var.availability_zone_1
  tags = {
    Name = "Covid Demo Private Subnet 1"
  }
}
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.covid_vpc.id
  cidr_block        = var.private_subnet_ips[1]
  availability_zone = var.availability_zone_2
  tags = {
    Name = "Covid Demo Private Subnet 2"
  }
}

# Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "Covid Demo NAT EIP"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet_1.id
  tags = {
    Name = "Covid Demo NAT Gateway"
  }
}

# Public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.covid_vpc.id
  tags = {
    Name = "Covid Public RTB"
  }
}
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.covid_igw.id
}

# Private route table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.covid_vpc.id
  tags = {
    Name = "Covid Private RTB"
  }
}
resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat_gateway.id
}

# Associate public subnets with public route table
resource "aws_route_table_association" "public_subnet_association_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}
resource "aws_route_table_association" "public_subnet_association_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate private subnets with private route table
resource "aws_route_table_association" "private_subnet_association_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}
resource "aws_route_table_association" "private_subnet_association_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}
