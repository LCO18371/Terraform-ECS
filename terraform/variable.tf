variable "region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name (e.g., usdev-usw2, usqa-usw2)"
  type        = string
  default     = "usdev-usw2"
}

# variable "vpc_cidr" {
#   description = "CIDR block for the VPC"
#   type        = string
#   default     = "10.0.0.0/16"
# }

# variable "public_subnet_cidrs" {
#   description = "CIDR blocks for public subnets"
#   type        = list(string)
#   default     = ["10.0.1.0/24", "10.0.2.0/24"]
# }

# variable "private_subnet_cidrs" {
#   description = "CIDR blocks for private subnets"
#   type        = list(string)
#   default     = ["10.0.3.0/24", "10.0.4.0/24"]
# }

# variable "container_port" {
#   description = "Port the container listens on"
#   type        = number
#   default     = 80
# }

# variable "container_cpu" {
#   description = "CPU units for the container (1024 = 1 vCPU)"
#   type        = number
#   default     = 256
# }

# variable "container_memory" {
#   description = "Memory for the container in MB"
#   type        = number
#   default     = 512
# }

# variable "desired_count" {
#   description = "Number of instances of the task to run"
#   type        = number
#   default     = 1
# }

# variable "alert_emails" {
#   description = "List of email addresses to receive alerts"
#   type        = list(string)
#   default     = []
# }

# # Common tags
variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    "ohi:project"     = "vlt"
    "ohi:application" = "vlt-subscription"
    "ohi:module"      = "vlt-subscription-be"
    "ohi:createdby"   = "terraform"
  }
}

# # Terraform CI/CD variables
# variable "terraform_codestar_connection_arn" {
#   description = "ARN of the CodeStar connection to GitHub/BitBucket for Terraform code"
#   type        = string
# }

# variable "terraform_repository_id" {
#   description = "GitHub/BitBucket repository ID for Terraform code (e.g., 'username/repo')"
#   type        = string
# }

# variable "terraform_branch_name" {
#   description = "Branch to use for Terraform code"
#   type        = string
#   default     = "main"
# }