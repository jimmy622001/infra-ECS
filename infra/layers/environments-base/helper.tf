data "aws_availability_zones" "available" {}

resource "random_id" "random_id" {
  byte_length = 8
}
