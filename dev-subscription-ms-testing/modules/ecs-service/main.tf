resource "aws_ecs_task_definition" "this" {
  family                   = "${var.environment}-${var.project}-subscription-ecs-task-definitions"
  requires_compatibilities = [var.launch_type]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.task_exec_role_arn

  container_definitions = jsonencode([
    {
      name      = "${var.environment}-${var.project}-subscription-container"
      image     = var.ecr_image
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ]
      essential = true
      
      # Health check configuration
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}${var.health_check_path} || exit 1"]
        interval    = var.health_check_interval
        timeout     = var.health_check_timeout
        retries     = var.health_check_retries
        startPeriod = var.health_check_start_period
      }
      
      # CloudWatch logs configuration
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.service.name
          "awslogs-region"        = data.aws_region.current.name
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])
  
  tags = {
    Name = "${var.environment}-${var.project}-subscription-ecs-task-definitions"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}

# CloudWatch Log Group for ECS Service
resource "aws_cloudwatch_log_group" "service" {
  name              = "/ecs/${var.environment}-${var.project}-subscription-ecs-service"
  retention_in_days = var.log_retention_days
  
  tags = {
    Name = "${var.environment}-${var.project}-subscription-logs"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}

resource "aws_ecs_service" "this" {
  name            = "${var.environment}-${var.project}-subscription-ecs-service"
  cluster         = var.cluster_name
  # Remove launch_type when using capacity_provider_strategy
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.this.arn

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.environment}-${var.project}-subscription-container"
    container_port   = var.container_port
  }

  health_check_grace_period_seconds = var.health_check_grace_period

  # Use either launch_type or capacity_provider_strategy, not both
  dynamic "capacity_provider_strategy" {
    for_each = var.enable_autoscaling ? [1] : []
    content {
      capacity_provider = "FARGATE"
      weight            = 1
      base              = 1
    }
  }
  
  # Only set launch_type when autoscaling is disabled
  launch_type = var.enable_autoscaling ? null : var.launch_type

  tags = {
    Name = "${var.environment}-${var.project}-subscription-ecs-service"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }

  depends_on = [aws_ecs_task_definition.this]
}

# Auto Scaling configuration
resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.enable_autoscaling ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# CPU-based Auto Scaling
resource "aws_appautoscaling_policy" "cpu_scaling" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${var.environment}-${var.project}-subscription-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value = var.cpu_threshold
  }
}

# Memory-based Auto Scaling
resource "aws_appautoscaling_policy" "memory_scaling" {
  count              = var.enable_autoscaling ? 1 : 0
  name               = "${var.environment}-${var.project}-subscription-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = var.memory_threshold
  }
}

data "aws_region" "current" {}
