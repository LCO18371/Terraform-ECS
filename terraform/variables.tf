variable "aws_country" {
  description = "The country code for the ECR repository"
  type        = string
  default     = "EU"
}
variable "aws_environment" {
  description = "The environment for the ECR repository"
  type        = string
  default     = "dev"  
}
variable "aws_region" {
  description = "The AWS region for the ECR repository"
  type        = string
  default     = "us-east-1"
}
variable "ecr_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "vlt-subscription-microservice-ecr"
}


variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "my-repository"
}
variable "image_tag_mutability" {
  description = "The image tag mutability setting for the ECR repository"
  type        = string
  default     = "MUTABLE" // or "IMMUTABLE"
}
variable "scan_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}
variable "lifecycle_prevent_destroy" {
  description = "Prevent the ECR repository from being destroyed"
  type        = bool
  default     = true
}
variable "tags" {
  description = "Tags to apply to the ECR repository"
  type        = map(string)
  default     = {
    Name = "my-repository"
  }
}
