resource "aws_ecr_repository" "this" {
  for_each = toset(var.repository_names)

  name                 = "${var.environment}-${var.project}-subscription-ecr"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  image_tag_mutability = var.image_tag_mutability

  tags = {
    Name = "${var.environment}-${var.project}-subscription-ecr"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  for_each = toset(var.repository_names)
  
  repository = aws_ecr_repository.this[each.key].name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last ${var.lifecycle_policy_days} days of images",
        selection = {
          tagStatus     = "untagged",
          countType     = "sinceImagePushed",
          countUnit     = "days",
          countNumber   = var.lifecycle_policy_days
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
