resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.environment}-igw"
    Environment = var.environment
    Repository  = var.repository
  }
}

resource "aws_eip" "nat" {
  count  = var.environment == "prod" ? local.azs_count : 1
  domain = "vpc"

  tags = {
    Name        = "${var.environment}-nat-eip-${count.index + 1}"
    Environment = var.environment
    Repository  = var.repository
  }

  depends_on = [aws_internet_gateway.main]
}

resource "aws_nat_gateway" "main" {
  count         = var.environment == "prod" ? local.azs_count : 1
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.environment}-nat-${count.index + 1}"
    Environment = var.environment
    Repository  = var.repository
  }
}
