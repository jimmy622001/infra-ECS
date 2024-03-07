########################################################################################################################
## ECS cluster
########################################################################################################################

resource "aws_ecs_cluster" "default" {
  name = "${var.resource_prefix}_ECSCluster_${var.environment}"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name     = "${var.resource_prefix}_ECSCluster_${var.environment}"
    Scenario = var.tag_scenario
  }
}

output "ecs_cluster_id" {
  value = aws_ecs_cluster.default.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.default.name
}
