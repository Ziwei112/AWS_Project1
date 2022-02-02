resource "aws_vpc" "vpc_jenkin" {
  cidr_block                       = var.cidr
  instance_tenancy                 = var.instance_tenancy
  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  enable_classiclink               = var.enable_classiclink

  tags = {
      Name = var.tags
    }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_jenkin.id

  tags = {
    Name = "internet-gateway-Jenkin"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id     = aws_vpc.vpc_jenkin.id
  map_public_ip_on_launch = true
  cidr_block = aws_vpc.vpc_jenkin.cidr_block

  tags = {
    Name = "public_1-demo"
  }
}

resource "aws_route_table" "route-public" {
  vpc_id = aws_vpc.vpc_jenkin.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public-route-table-Jenkin"
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.route-public.id
}