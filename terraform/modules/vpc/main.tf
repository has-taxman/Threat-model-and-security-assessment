#########################################################
# VPC and Subnet configuration
#########################################################

# Create the VPC.
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "threat-model-VPC"
  }
}

# Create an Internet Gateway for public subnet access.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "threat-model-IGW"
  }
}

# Fetch availability zones.
data "aws_availability_zones" "available" {}

# Create public subnets.
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)            
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]       
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "threat-model-PublicSubnet-${count.index + 1}"
  }
}

# Create private subnets.
resource "aws_subnet" "private" {
  count             = length(var.private_subnets)           
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "threat-model-PrivateSubnet-${count.index + 1}"
  }
}

# Public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "threat-model-Public-RT"
  }
}

# Add a route for Internet access.
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Associate the public subnets with the route table.
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "nat" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "threat-model-NAT"
  }
}
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "threat-model-Private-RT"
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id          = aws_nat_gateway.nat.id
}
resource "aws_route_table_association" "private" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
