resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main.id
  service_name = "com.amazonaws.${var.region}.s3"
  tags = {
    Name        = "${var.name}-s3-vpc-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = length(compact(var.private_subnets))
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
  route_table_id  = element(aws_route_table.private.*.id, count.index)
}
