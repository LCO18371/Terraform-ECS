variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "subscription"
}

variable "api_gateway_sg_id" {
  description = "Security group ID for API Gateway VPC Link"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for VPC Link"
  type        = list(string)
}

variable "alb_listener_arn" {
  description = "ARN of the ALB listener"
  type        = string
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

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
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