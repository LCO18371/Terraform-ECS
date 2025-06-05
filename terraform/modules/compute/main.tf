resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-vlt-subscription-ecs-cluster"
  
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  
  tags = var.tags
}