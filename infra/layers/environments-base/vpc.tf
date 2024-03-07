########################################################################################################################
## VPC
########################################################################################################################

resource "aws_vpc" "default" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name     = "${var.resource_prefix}_VPC_${var.environment}"
    Scenario = var.tag_scenario
  }
}

output "vpc_id" {
  value = aws_vpc.default.id
}

output "vpc_cidr_block" {
  value = aws_vpc.default.cidr_block
}

########################################################################################################################
## Internet Gateway for public subnets
########################################################################################################################

resource "aws_internet_gateway" "default" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name     = "${var.resource_prefix}_InternetGateway_${var.environment}"
    Scenario = var.tag_scenario
  }
}
