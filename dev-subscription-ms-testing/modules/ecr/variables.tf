variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "scan_on_push" {
  description = "Enable image scan on push"
  type        = bool
  default     = true
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "MUTABLE"  # Setting default to MUTABLE as requested
}

variable "lifecycle_policy_days" {
  description = "Number of days to keep images before expiring them"
  type        = number
  default     = 30  # Setting default to 30 days as requested
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
