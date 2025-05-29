variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ecr_repository_url" {
  description = "URL of the ECR repository"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
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

variable "buildspec_path" {
  description = "Path to the buildspec file"
  type        = string
  default     = "buildspec.yml"
}

variable "artifacts_bucket" {
  description = "S3 bucket for pipeline artifacts"
  type        = string
  default     = ""
}

# Add these variables for tagging and naming
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
