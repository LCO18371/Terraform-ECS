output "ecr_repo_uris" {
  description = "Map of repository names to their URIs"
  value = {
    for repo_name, repo in aws_ecr_repository.name :
    repo_name => repo.repository_url
  }
}
