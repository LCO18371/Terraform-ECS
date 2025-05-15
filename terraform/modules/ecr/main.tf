resource "aws_ecr_repository" "my_repository" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.image_tag_mutability // or "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = var.tags
}

