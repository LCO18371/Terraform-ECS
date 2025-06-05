resource "aws_ecr_repository" "name" {
  for_each = toset(var.repository_names)
  name                 = "${var.environment}-vlt-${each.key}"
  image_tag_mutability = "MUTABLE"
  
  image_scanning_configuration {
    scan_on_push = true
  }
  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-vlt-${each.key}"
    }
  )
}

resource "aws_ecr_lifecycle_policy" "rules" {
    depends_on = [ aws_ecr_repository.name ]
  for_each = aws_ecr_repository.name
  
  repository = each.value.name
  
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Remove untagged images after 1 day",
        selection = {
          tagStatus     = "untagged",
          countType     = "sinceImagePushed",
          countUnit     = "days",
          countNumber   = 1
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}