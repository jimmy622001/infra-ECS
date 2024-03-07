resource "aws_eip" "nat_gateway" {
  count = var.az_count
  vpc   = true

  tags = {
    Name     = "${var.resource_prefix}_EIP_${count.index}_${random_id.random_id.hex}"
    Scenario = var.tag_scenario
  }
}

resource "aws_nat_gateway" "nat_gateway" {
  count         = var.az_count
  subnet_id     = aws_subnet.public.*.id[count.index]
  allocation_id = aws_eip.nat_gateway.*.id[count.index]

  tags = {
    Name     = "${var.resource_prefix}_NatGateway_${count.index}_${random_id.random_id.hex}"
    Scenario = var.tag_scenario
  }
}

resource "aws_subnet" "private" {
  count             = var.az_count
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.available.names[count.index]
  vpc_id            = aws_vpc.default.id

  tags = {
    Name                                              = "${var.resource_prefix}_PrivateSubnet_${count.index}_${random_id.random_id.hex}"
    Scenario                                          = var.tag_scenario
  }
}

resource "aws_route_table" "private" {
  count  = var.az_count
  vpc_id = aws_vpc.default.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.*.id[count.index]
  }

  tags = {
    Name     = "${var.resource_prefix}_PrivateRouteTable_${count.index}_${random_id.random_id.hex}"
    Scenario = var.tag_scenario
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = aws_subnet.private.*.id[count.index]
  route_table_id = aws_route_table.private.*.id[count.index]
}
