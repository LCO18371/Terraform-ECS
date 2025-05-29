output "alb_dns_name" {
  description = "DNS name of the load balancer"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "alb_arn" {
  description = "ARN of the load balancer"
  value       = aws_lb.this.arn
}

output "alb_listener_arn" {
  description = "ARN of the load balancer listener"
  value       = aws_lb_listener.http.arn
}

output "target_group_arn_suffix" {
  description = "ARN suffix of the target group for CloudWatch metrics"
  value       = aws_lb_target_group.this.arn_suffix
}

output "load_balancer_arn_suffix" {
  description = "ARN suffix of the load balancer for CloudWatch metrics"
  value       = aws_lb.this.arn_suffix
}