########################################################################################################################
## Public application load balancer for external services (exposed services with public ingress access)
########################################################################################################################

resource "aws_alb" "alb" {
  name            = "${replace(var.resource_prefix, "_", "-")}-ALB-${var.environment}"
  security_groups = [aws_security_group.alb.id]
  subnets         = aws_subnet.public.*.id

  tags = {
    Scenario = var.tag_scenario
  }
}

output "alb_name" {
  value = aws_alb.alb.name
}

output "alb_dns_name" {
  value = aws_alb.alb.dns_name
}

resource "aws_alb_listener" "alb_default_listener_http" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = {
    Scenario = var.tag_scenario
  }
}

output "alb_default_listener_http_arn" {
  value = aws_alb_listener.alb_default_listener_http.arn
}

resource "aws_alb_listener" "alb_default_listener_https" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = data.terraform_remote_state.common.outputs.alb_certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-Ext-2018-06"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Access denied"
      status_code  = "403"
    }
  }

  tags = {
    Scenario = var.tag_scenario
  }
}

output "alb_default_listener_https_arn" {
  value = aws_alb_listener.alb_default_listener_https.arn
}