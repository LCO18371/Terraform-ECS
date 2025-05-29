variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "subscription"
}

variable "artifacts_bucket" {
  description = "S3 bucket for pipeline artifacts"
  type        = string
}

variable "artifacts_bucket_arn" {
  description = "ARN of S3 bucket for pipeline artifacts"
  type        = string
}

variable "codestar_connection_arn" {
  description = "ARN of the CodeStar connection to GitHub/BitBucket"
  type        = string
}

variable "terraform_repository_id" {
  description = "GitHub/BitBucket repository ID for Terraform code"
  type        = string
}

variable "terraform_branch_name" {
  description = "Branch to use for the Terraform code"
  type        = string
  default     = "main"
}

variable "terraform_version" {
  description = "Version of Terraform to use"
  type        = string
  default     = "1.0.11"
}
