output "pipeline_name" {
  description = "Name of the Terraform CodePipeline"
  value       = aws_codepipeline.terraform_pipeline.name
}

output "artifact_bucket" {
  description = "S3 bucket for Terraform pipeline artifacts"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "state_bucket" {
  description = "S3 bucket for Terraform state"
  value       = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_table" {
  description = "DynamoDB table for Terraform locks"
  value       = aws_dynamodb_table.terraform_locks.name
}