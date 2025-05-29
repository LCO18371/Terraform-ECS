variable "vpc_id" {
  description = "The VPC ID where security groups will be created"
  type        = string
}

variable "container_port" {
  description = "Port ECS container listens on"
  type        = number
  default     = 80
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
