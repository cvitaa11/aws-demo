resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-public-rt"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table" "private" {
  count  = var.environment == "prod" ? local.azs_count : 1
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-private-rt-${count.index + 1}"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_route" "private_nat_gateway" {
  count                  = var.environment == "prod" ? local.azs_count : 1
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main[count.index].id
}

resource "aws_route_table_association" "private" {
  count          = local.azs_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = var.environment == "prod" ? aws_route_table.private[count.index].id : aws_route_table.private[0].id
}

resource "aws_route_table_association" "public" {
  count          = local.azs_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
