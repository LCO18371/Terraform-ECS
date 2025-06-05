resource "aws_ecs_task_definition" "this" {
  family                   = "${var.environment}-vlt-subscription-ecs-task-definitions"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.task_exec_role_arn
  
  container_definitions = jsonencode([
    {
      name      = "${var.environment}-vlt-subscription-container"
      image     = var.ecr_image
      essential = true
      
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.cluster_name}"
          "awslogs-region"        = "us-west-2"
          "awslogs-stream-prefix" = "subscription"
        }
      }
    }
  ])
  
  tags = var.tags
}

resource "aws_ecs_service" "this" {
  name            = var.service_name
  cluster         = var.cluster_name
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  
  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }
  
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "${var.environment}-vlt-subscription-container"
    container_port   = var.container_port
  }
  
  tags = var.tags
}