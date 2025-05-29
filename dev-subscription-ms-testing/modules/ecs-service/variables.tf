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
  description = "Security group ID for the ECS service"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the ECS service"
  type        = list(string)
}

variable "ecr_image" {
  description = "ECR image URI"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the target group"
  type        = string
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "CPU units for the task"
  type        = string
  default     = "256"  # Setting default to 256 as requested
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = string
  default     = "512"  # Setting default to 512 as requested
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80  # Setting default to 80 as requested
}

variable "launch_type" {
  description = "Launch type for the ECS service"
  type        = string
  default     = "FARGATE"  # Setting default to FARGATE as requested
}

variable "health_check_path" {
  description = "Path for container health checks"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Interval for health checks (in seconds)"
  type        = number
  default     = 30
}

variable "health_check_timeout" {
  description = "Timeout for health checks (in seconds)"
  type        = number
  default     = 5
}

variable "health_check_retries" {
  description = "Number of retries for health checks"
  type        = number
  default     = 3
}

variable "health_check_start_period" {
  description = "Start period for health checks (in seconds)"
  type        = number
  default     = 60
}

variable "health_check_grace_period" {
  description = "Grace period for health checks (in seconds)"
  type        = number
  default     = 60
}

variable "enable_autoscaling" {
  description = "Whether to enable auto scaling"
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 10
}

variable "cpu_threshold" {
  description = "CPU threshold for auto scaling"
  type        = number
  default     = 70
}

variable "memory_threshold" {
  description = "Memory threshold for auto scaling"
  type        = number
  default     = 70
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

# Variables for tagging and naming
variable "environment" {
  description = "Environment"
  type        = string
  default     = "usdev-usw2"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "vlt"
}

variable "application" {
  description = "Application name"
  type        = string
  default     = "vlt-subscription"
}

variable "module" {
  description = "Module name"
  type        = string
  default     = "vlt-subscription-be"
}
