#----------------------------------- VPC BLOCK -------------------------------------------# 
resource "aws_vpc" "vpc_3tier" {
  cidr_block = var.cidr_vpc

  tags = {
    Name = var.vpc_name
  }
}
#--------------------------------------- SUBNET BLOCKS ---------------------------------------#
resource "aws_subnet" "web_public" {
  for_each = var.cidr_web_public

  vpc_id                  = aws_vpc.vpc_3tier.id
  cidr_block              = each.value
  availability_zone       = join("", [var.aws_region, each.key])
  map_public_ip_on_launch = true

  # count = length(var.cidr_web_public)

  # vpc_id     = aws_vpc.vpc_3tier.id
  # cidr_block = var.cidr_web_public[count.index]
  # availability_zone       = "${var.aws_region}${var.availability_zones[count.index]}"
  # map_public_ip_on_launch = true

  tags = {
    Name = join("", ["WebSubnetPublic-", each.key])
    #Name = "WebSubnetPublic-${var.availability_zones[count.index]}"
  }
}

resource "aws_subnet" "app_private" {
  for_each = var.cidr_app_private

  vpc_id            = aws_vpc.vpc_3tier.id
  cidr_block        = each.value
  availability_zone = join("", [var.aws_region, each.key])

  tags = {
    Name = join("", ["AppSubnetPrivate-", each.key])
  }
}

resource "aws_subnet" "data_private" {
  for_each = var.cidr_data_private

  vpc_id            = aws_vpc.vpc_3tier.id
  cidr_block        = each.value
  availability_zone = join("", [var.aws_region, each.key])

  tags = {
    Name = join("", ["DataSubnetPrivate-", each.key])
  }
}
#------------------------------ GATEWAYS & ELASTIC IP BLOCKS ------------------------------------#
resource "aws_internet_gateway" "int_gw" {
  vpc_id = aws_vpc.vpc_3tier.id

  tags = {
    Name = "IGW"
  }
}

resource "aws_eip" "nat_ip" {
  #count = 3
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {

  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.web_public["a"].id
  #subnet_id = aws_subnet.web_public[0].id

  tags = {
    Name = "NATGW"
  }

  depends_on = [aws_internet_gateway.int_gw]
}
#------------------------- ROUTE TABLES & ROUTE TABLE ASSOCIATIONS ---------------------------#
resource "aws_route_table" "internet_route_tbl" {
  vpc_id = aws_vpc.vpc_3tier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.int_gw.id
  }



  tags = {
    Name = "internet-route-table"
  }
}

resource "aws_route_table" "nat_route_tbl" {
  vpc_id = aws_vpc.vpc_3tier.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }



  tags = {
    Name = "nat-route-table"
  }
}

resource "aws_route_table_association" "web_public" {
  for_each = aws_subnet.web_public
  #count = length(var.cidr_web_public)

  subnet_id = each.value.id
  #subnet_id      = element(aws_subnet.web_public.*.id, count.index)
  route_table_id = aws_route_table.internet_route_tbl.id
}

resource "aws_route_table_association" "app_private" {
  for_each = aws_subnet.app_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.nat_route_tbl.id
}

resource "aws_route_table_association" "data_private" {
  for_each = aws_subnet.data_private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.nat_route_tbl.id
}