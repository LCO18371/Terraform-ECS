variable "ecr_repo_name" {
  description = "The name of the ECR repository"
  type        = string
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
# variable "lifecycle" {
#   description = "Prevent the ECR repository from being destroyed"
#   type        = bool
#   default     = true
# }
variable "tags" {
  description = "Tags to apply to the ECR repository"
  type        = map(string)
  default     = {
    Name = "my-repository"
  }
}
