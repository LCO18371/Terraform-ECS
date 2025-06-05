variable "environment" {
  description = "Environment name (e.g., usdev-usw2, usqa-usw2)"
  type        = string
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_exec_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "ecs_sg_id" {
  description = "ID of the ECS security group"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of subnets where the service will be deployed"
  type        = list(string)
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8080
}

variable "ecr_image" {
  description = "ECR image to use for the container"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}