########################################################################################################################
# ALB certificate
########################################################################################################################

resource "aws_acm_certificate" "alb_certificate" {
  domain_name               = var.service_tld
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.service_tld}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name     = var.service_tld
    Scenario = var.tag_scenario
  }
}

output "alb_certificate_arn" {
  value = aws_acm_certificate.alb_certificate.arn
}

########################################################################################################################
# CloudFront certificate in North Virginia region
########################################################################################################################

resource "aws_acm_certificate" "cloudfront_certificate" {
  provider                  = aws.us_east_1
  domain_name               = var.service_tld
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.service_tld}"]

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name     = var.service_tld
    Scenario = var.tag_scenario
  }
}

output "cloudfront_certificate_arn" {
  value = aws_acm_certificate.cloudfront_certificate.arn
}
