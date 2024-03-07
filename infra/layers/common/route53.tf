########################################################################################################################
# Hosted zone
########################################################################################################################

resource "aws_route53_zone" "service" {
  name  = var.service_tld

  tags = {
    Scenario = var.tag_scenario
  }
}

output "service_zone_id" {
  value = aws_route53_zone.service.id
}

output "service_domain_name" {
  value = aws_route53_zone.service.name
}
