# Networking module: VPC, Subnets, IGW, NAT
module "networking" {
  source               = "./modules/networking"
  region               = var.region
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  environment          = var.environment
  project              = var.project
  application          = var.application
  module               = var.module
}

# Security module: Security groups, IAM roles
module "security" {
  source         = "./modules/security"
  vpc_id         = module.networking.vpc_id
  container_port = var.container_port
  environment    = var.environment
  project        = var.project
  application    = var.application
  module         = var.module
}

# ALB module
module "alb" {
  source             = "./modules/alb"
  vpc_id             = module.networking.vpc_id
  public_subnet_ids  = module.networking.public_subnet_ids
  private_subnet_ids = module.networking.private_subnet_ids
  alb_sg_id          = module.security.alb_sg_id
  internal           = var.use_api_gateway
  target_port        = var.container_port
  health_check_path  = var.health_check_path
  environment        = var.environment
  project            = var.project
  application        = var.application
  module             = var.module
}

# API Gateway module (conditional)
module "api_gateway" {
  source             = "./modules/api-gateway"
  count              = var.use_api_gateway ? 1 : 0
  name_prefix        = var.name_prefix
  api_gateway_sg_id  = module.security.api_gateway_sg_id
  private_subnet_ids = module.networking.private_subnet_ids
  alb_listener_arn   = module.alb.alb_listener_arn
  domain_name        = var.domain_name
  certificate_arn    = var.certificate_arn
  hosted_zone_id     = var.hosted_zone_id
  log_retention_days = var.log_retention_days
  environment        = var.environment
  project            = var.project
  application        = var.application
  module             = var.module
  
  depends_on = [module.alb, module.security]
}

# Compute module: ECS Cluster only
module "compute" {
  source             = "./modules/compute"
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  environment        = var.environment
  project            = var.project
  application        = var.application
  module             = var.module
}

# ECR module: ECR repositories
module "ecr" {
  source           = "./modules/ecr"
  repository_names = ["subscription-microservice"]
  environment      = var.environment
  project          = var.project
  application      = var.application
  module           = var.module
}

# ECS Service module: Task definition and ECS service
module "ecs_service" {
  source                = "./modules/ecs-service"
  cluster_name          = module.compute.ecs_cluster_name
  service_name          = "${var.name_prefix}-service"
  task_exec_role_arn    = module.security.ecs_task_execution_role_arn
  ecs_sg_id             = module.security.ecs_sg_id
  subnet_ids            = module.networking.private_subnet_ids
  container_port        = var.container_port
  ecr_image             = "${module.ecr.ecr_repo_uris["subscription-microservice"]}:latest"
  target_group_arn      = module.alb.target_group_arn
  desired_count         = var.desired_count
  cpu                   = var.task_cpu
  memory                = var.task_memory
  health_check_path     = var.health_check_path
  enable_autoscaling    = var.enable_autoscaling
  min_capacity          = var.min_capacity
  max_capacity          = var.max_capacity
  log_retention_days    = var.log_retention_days
  environment           = var.environment
  project               = var.project
  application           = var.application
  module                = var.module
}

# Monitoring module
module "monitoring" {
  source                  = "./modules/monitoring"
  region                  = var.region
  ecs_cluster_name        = module.compute.ecs_cluster_name
  ecs_service_name        = module.ecs_service.service_name
  alert_emails            = var.alert_emails
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  load_balancer_arn_suffix = module.alb.load_balancer_arn_suffix
  log_retention_days      = var.log_retention_days
  environment             = var.environment
  project                 = var.project
  application             = var.application
  module                  = var.module
}

# S3 bucket for application pipeline artifacts
resource "aws_s3_bucket" "app_artifacts" {
  bucket = "${var.environment}-${var.project}-subscription-app-artifacts"
  
  tags = {
    Name = "${var.environment}-${var.project}-subscription-app-artifacts"
    "ohi:project" = var.project
    "ohi:application" = var.application
    "ohi:module" = var.module
    "ohi:environment" = var.environment
  }
}

resource "aws_s3_bucket_versioning" "app_artifacts" {
  bucket = aws_s3_bucket.app_artifacts.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CI/CD Pipeline module for application deployment
module "cicd" {
  source                 = "./modules/cicd"
  project_name           = var.name_prefix
  ecr_repository_url     = module.ecr.ecr_repo_uris["subscription-microservice"]
  ecs_cluster_name       = module.compute.ecs_cluster_name
  ecs_service_name       = module.ecs_service.service_name
  codestar_connection_arn = var.codestar_connection_arn
  repository_id          = var.repository_id
  branch_name            = var.branch_name
  artifacts_bucket       = aws_s3_bucket.app_artifacts.bucket
  environment            = var.environment
  project                = var.project
  application            = var.application
  module                 = var.module
}

# ---------------------
# Outputs
# ---------------------

output "vpc_id" {
  value = module.networking.vpc_id
}

output "ecs_cluster_name" {
  value = module.compute.ecs_cluster_name
}

output "ecs_service_name" {
  value = module.ecs_service.service_name
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "api_gateway_endpoint" {
  value = var.use_api_gateway ? module.api_gateway[0].api_endpoint : null
  description = "API Gateway endpoint URL (if enabled)"
}

output "ecr_repo_url" {
  value = module.ecr.ecr_repo_uris["subscription-microservice"]
}

output "app_pipeline_name" {
  value = module.cicd.pipeline_name
}

output "cloudwatch_log_group" {
  value = module.monitoring.log_group_name
}
