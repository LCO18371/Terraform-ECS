variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "alert_emails" {
  description = "List of email addresses to receive alerts"
  type        = list(string)
  default     = []
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub/BitBucket"
  type        = string
}

variable "repository_id" {
  description = "GitHub/BitBucket repository ID (e.g., 'username/repo')"
  type        = string
}

variable "branch_name" {
  description = "Branch to use for the source code"
  type        = string
  default     = "main"
}

# New variables for enhanced configuration

variable "use_api_gateway" {
  description = "Whether to use API Gateway in front of the ALB"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Custom domain name for API Gateway"
  type        = string
  default     = ""
}

variable "certificate_arn" {
  description = "ARN of ACM certificate for custom domain"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route 53 hosted zone ID for custom domain"
  type        = string
  default     = ""
}

variable "health_check_path" {
  description = "Path for health checks"
  type        = string
  default     = "/health"
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}

variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory for the ECS task in MiB"
  type        = string
  default     = "512"
}

variable "enable_autoscaling" {
  description = "Whether to enable ECS service autoscaling"
  type        = bool
  default     = true
}

variable "min_capacity" {
  description = "Minimum number of ECS tasks"
  type        = number
  default     = 2
}

variable "max_capacity" {
  description = "Maximum number of ECS tasks"
  type        = number
  default     = 10
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "terraform_repository_id" {
  description = "GitHub/BitBucket repository ID for Terraform code"
  type        = string
  default     = "ankitkanojia786/subscription-microservices-testing"
}

variable "terraform_branch_name" {
  description = "Branch to use for the Terraform code"
  type        = string
  default     = "main"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "subscription"
}

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
