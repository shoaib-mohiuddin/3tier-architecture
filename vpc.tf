resource "aws_vpc" "vpc_3tier" {
  cidr_block = var.cidr_vpc

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "web_public" {
  for_each = var.cidr_web_public

  vpc_id     = aws_vpc.vpc_3tier.id
  cidr_block = each.value
  availability_zone = join("", [var.aws_region, each.key])

  tags = {
    Name = join("", ["WebSubnetPublic-", each.key])
  }
}

resource "aws_subnet" "app_private" {
  for_each = var.cidr_app_private

  vpc_id     = aws_vpc.vpc_3tier.id
  cidr_block = each.value
  availability_zone = join("", [var.aws_region, each.key])

  tags = {
    Name = join("", ["AppSubnetPrivate-", each.key])
  }
}

resource "aws_subnet" "data_private" {
  for_each = var.cidr_data_private

  vpc_id     = aws_vpc.vpc_3tier.id
  cidr_block = each.value
  availability_zone = join("", [var.aws_region, each.key])

  tags = {
    Name = join("", ["DataSubnetPrivate-", each.key])
  }
}