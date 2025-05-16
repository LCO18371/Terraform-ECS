resource "aws_ecr_repository" "my_repository" {
  name                 = var.ecr_repo_name
  image_tag_mutability = var.image_tag_mutability // or "IMMUTABLE"
  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "rule" {
  repository = aws_ecr_repository.my_repository.name
  policy = jsonencode({
  rules = [
    {
      rulePriority = 1
      description  = "Delete all images after 30 days"
      selection = {
        tagStatus     = "any"
        countType     = "imageCountMoreThan"
        countNumber   = 30
      }
      action = {
        type = "expire"
      }
    }
  ]
})
  
}
# docker tag hello-world:latest 010438474962.dkr.ecr.us-east-1.amazonaws.com/hellorepository
# aws ecr get-login-password --region us-east-1 | docker login --username AWS --passwordstdin 010438474962.dkr.ecr.region.amazonaws.com
# docker push 010438474962.dkr.ecr.us-east-1.amazonaws.com/hello-repository:latest
