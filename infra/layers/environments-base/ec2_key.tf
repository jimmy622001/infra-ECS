########################################################################################################################
## EC2 key pair
########################################################################################################################

resource "aws_key_pair" "default" {
  key_name   = "${var.resource_prefix}_KeyPair_${var.environment}"
  public_key = var.ec2_key

  tags = {
    Scenario = var.tag_scenario
  }
}
