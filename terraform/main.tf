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
  ecr_repo_name = var.environment == "dev" ? "${var.environment}-${var.ecr_repo_name}" : var.environment == "stg" ? "${var.environment}-${var.ecr_repo_name}" : var.environment == "prod" ? "prod-${var.ecr_repo_name}" : var.ecr_repo_name
  tags = var.tags 
}



resource "aws_ecs_cluster" "cluster" {
  name       = "my-cluster"
  tags = {
    Name = "my-cluster"
  }
}
# resource "aws_iam_role" "name" {
#     name               = "my-iam-role"
#     assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  
# }
resource "aws_ecs_task_definition" "task_defination" {
  family                   = "Ravi-my-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "512"
  memory                   = "1024"
  #task_role_arn            = aws_iam_role.task_role.arn
  #execution_role_arn       = aws_iam_role.execution_role.arn


  container_definitions = jsonencode([
    {
      name      = "my-container"
      image     = "nginx:latest" //ecr rep refrence
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


}