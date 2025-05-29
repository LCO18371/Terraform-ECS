output "alb_sg_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "ecs_sg_id" {
  description = "Security group ID for ECS Tasks"
  value       = aws_security_group.ecs_sg.id
}

output "ecs_task_execution_role_arn" {
  description = "IAM Role ARN for ECS task execution"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "api_gateway_sg_id" {
  description = "ID of the API Gateway security group"
  value       = aws_security_group.api_gateway.id
}