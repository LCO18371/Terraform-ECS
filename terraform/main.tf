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
resource "aws_ecr_repository" "my_repository" {
    name = "my-repository"
    image_tag_mutability = "MUTABLE"
    image_scanning_configuration {
        scan_on_push = true
    }
    lifecycle {
        prevent_destroy = true
    }
    tags = {
        Name = "my-repository"
    }
}


resource "aws_ecs_cluster" "cluster" {
    name = "my-cluster"
  
}
resource "aws_ecs_task_definition" "task_defination" {
    family                   = "Ravi-my-task"
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                     = "512"
    memory                  = "1024"
  
    container_definitions = jsonencode([
        {
            name      = "my-container"
            image     = "nginx:latest"
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort     = 80
                    protocol     = "tcp"
                }
            ]
        }
    ])
  
}