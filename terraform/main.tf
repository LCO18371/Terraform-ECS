#Step 1: ECR repositories creation

#----------------------------------------------local tags------------------------------------------------
# Define local variables
locals {
  # Merge common tags with environment-specific tag
  tags = merge(var.tags, {
    "ohi:environment" = var.environment
  })
}






#----------------------------------------------local tags------------------------------------------------

# ECR module: ECR repositories
module "ecr" {
  source           = "./modules/ecr"
  environment      = var.environment
  repository_names = ["microservice"]
  tags             = local.tags
}