resource "aws_subnet" "public" {
  count                   = var.az_count
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, var.az_count + count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  vpc_id                  = aws_vpc.default.id
  map_public_ip_on_launch = true

  tags = {
    Name     = "${var.resource_prefix}_PublicSubnet_${count.index}_${random_id.random_id.hex}"
    Scenario = var.tag_scenario
  }
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.default.id
  }

  tags = {
    Name     = "${var.resource_prefix}_PublicRouteTable_${random_id.random_id.hex}"
    Scenario = var.tag_scenario
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.id
}

resource "aws_main_route_table_association" "public_main" {
  vpc_id         = aws_vpc.default.id
  route_table_id = aws_route_table.public.id
}
