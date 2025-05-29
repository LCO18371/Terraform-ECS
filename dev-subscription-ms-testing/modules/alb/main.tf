resource "aws_lb" "this" {
  name               = "${var.environment}-${var.project}-subscription-alb"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.internal ? var.private_subnet_ids : var.public_subnet_ids

  enable_deletion_protection = false
  
  tags = {
    Name = "${var.environment}-${var.project}-subscription-alb"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}

resource "aws_lb_target_group" "this" {
  name     = "${var.environment}-${var.project}-subscription-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = var.health_check_interval
    timeout             = var.health_check_timeout
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    matcher             = var.health_check_matcher
  }
  
  tags = {
    Name = "${var.environment}-${var.project}-subscription-tg"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
