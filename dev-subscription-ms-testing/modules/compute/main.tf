resource "aws_ecs_cluster" "this" {
  name = "${var.environment}-${var.project}-subscription-ecs-cluster"
  
  tags = {
    Name = "${var.environment}-${var.project}-subscription-ecs-cluster"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}
