variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
  default     = []
}

variable "alb_sg_id" {
  description = "Security group ID to attach to the ALB"
  type        = string
}

variable "target_port" {
  description = "Target port ECS container is listening on"
  type        = number
  default     = 80  # Updated to 80 as requested
}

variable "internal" {
  description = "Whether the load balancer is internal or internet-facing"
  type        = bool
  default     = true
}

variable "health_check_path" {
  description = "Path for ALB health checks"
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

variable "health_check_healthy_threshold" {
  description = "Number of consecutive successful health checks"
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive failed health checks"
  type        = number
  default     = 3
}

variable "health_check_matcher" {
  description = "HTTP response codes to consider healthy"
  type        = string
  default     = "200-299"
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
