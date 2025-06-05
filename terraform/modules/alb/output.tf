output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_id" {
  value = aws_lb.this.id
}

output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}