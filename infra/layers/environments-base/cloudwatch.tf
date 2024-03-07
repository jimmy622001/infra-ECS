resource "aws_ssm_parameter" "cloudwatch_agent" {
  name      = "${var.environment}.cloudwatch-agent-config.json"
  type      = "String"
  value     = file("${path.module}/agent-config.json")
  overwrite = true

  tags = {
    Scenario = var.tag_scenario
  }
}
