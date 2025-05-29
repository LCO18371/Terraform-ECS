terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}
# step 1 create a repository
module "ecr" {
  source = "./modules/ecr"
  #ecr_repo_name = var.environment == "dev" ? "${var.environment}-${var.ecr_repo_name}" : var.environment == "stg" ? "${var.environment}-${var.ecr_repo_name}" : var.environment == "prod" ? "prod-${var.ecr_repo_name}" : var.ecr_repo_name
  ecr_repo_name = "${var.aws_country}-${var.aws_environment}-${var.ecr_name}"
  image_tag_mutability = var.image_tag_mutability
  scan_on_push = var.scan_on_push
  tags = var.tags 
}



resource "aws_ecs_cluster" "cluster" {
  name       = "my-cluster"
  tags = {
    Name = "my-cluster"
  }
}
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.aws_environment}-ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecs_task_execution_policy" {
  name        = "${var.aws_environment}-ecs-execution-policy"
  description = "Policy for ECS to pull images and push logs"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameters",
          "secretsmanager:GetSecretValue"
        ],
        Resource = "*"
      }
    ]
  })
}
# roles

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_policy.arn
}

resource "aws_iam_role" "ecs_task_role" {
  name = "${var.aws_environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.aws_environment}-ecs-task-policy"
  description = "Policy for ECS containers to access AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:*",
          "s3:*",
          "sqs:*",
          "sns:*"
        ],
        Resource = "*"
      }
    ]
  })
}

# resource "aws_iam_role_policy_attachment" "ecs_task_policy_attach" {
#   role       = aws_iam_role.ecs_task_role.name
#   policy_arn = aws_iam_policy.ecs_task_policy.arn
# }

resource "aws_ecs_task_definition" "task_defination" {
  family                   = "Ravi-my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "nginx:latest" //ecr rep refrence
      environment = [
        {
          name  = "ENV_VAR_1"
          value = "value1"
        },
        {
          name  = "ENV_VAR_2"
          value = "value2"
        }
      ]
      essential = true
      readonlyRootFilesystem = false
    #   private_docker_repository_credentials = {
    #     credentials_parameter = aws_secretsmanager_secret.my_secret.arn
    #   }
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
      
    }
  ])
  
  tags = {
    Name = "my-task-definition"
  }


}

# resource "aws_lb" "Network_lb" {
#   name               = "${var.environment}-network-lb"
#   internal           = false
#   load_balancer_type = "network"
#   security_groups    = [aws_security_group.ecs_sg.id]
#   subnets            = var.subnets

#   enable_deletion_protection = false

#   tags = {
#     Name = "${var.environment}-network-lb"
#   }
  
# }