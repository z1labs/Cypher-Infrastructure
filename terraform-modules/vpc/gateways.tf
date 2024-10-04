resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.name}-igw"
  }
}

resource "aws_nat_gateway" "main" {
  # count         = length(compact(var.availability_zones))
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  tags = {
    Name        = "${var.name}-nat"
  }
}

resource "aws_eip" "nat" {
  # count = length(compact(var.availability_zones))
  vpc   = true
  tags = {
    Name        = "${var.name}-nat"
  }
}
