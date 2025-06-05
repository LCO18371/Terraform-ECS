resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.ecs_cluster_name}"
  retention_in_days = 30
  
  tags = merge(
    var.tags,
    {
      Name = "${var.environment}-vlt-subscription-logs"
    }
  )
}

resource "aws_sns_topic" "alerts" {
  name = "${var.environment}-vlt-subscription-alerts"
  
  tags = var.tags
}

resource "aws_sns_topic_subscription" "email_alerts" {
  count     = length(var.alert_emails)
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_emails[count.index]
}

resource "aws_cloudwatch_metric_alarm" "ecs_cpu_high" {
  alarm_name          = "${var.environment}-vlt-subscription-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors ECS CPU utilization"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  
  dimensions = {
    ClusterName = var.ecs_cluster_name
  }
  
  tags = var.tags
}