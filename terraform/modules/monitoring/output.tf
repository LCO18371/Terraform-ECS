output "log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.ecs_logs.name
}

output "sns_topic_arn" {
  description = "ARN of the SNS Topic for alerts"
  value       = aws_sns_topic.alerts.arn
}
