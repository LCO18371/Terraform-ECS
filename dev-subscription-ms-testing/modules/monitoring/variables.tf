variable "region" {
  description = "AWS region"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = ""
}

variable "alert_emails" {
  description = "List of email addresses to receive alerts"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group for CloudWatch metrics"
  type        = string
  default     = ""
}

variable "load_balancer_arn_suffix" {
  description = "ARN suffix of the load balancer for CloudWatch metrics"
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
