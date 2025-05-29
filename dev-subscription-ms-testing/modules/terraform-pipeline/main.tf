resource "aws_s3_bucket" "terraform_state" {
  bucket = "${var.name_prefix}-terraform-state"
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "${var.name_prefix}-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  
  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_codebuild_project" "terraform_plan" {
  name          = "${var.name_prefix}-terraform-plan"
  description   = "Plan Terraform changes"
  service_role  = aws_iam_role.terraform_codebuild_role.arn
  build_timeout = 10
  
  artifacts {
    type = "CODEPIPELINE"
  }
  
  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
  }
  
  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOT
      version: 0.2
      phases:
        install:
          runtime-versions:
            python: 3.8
          commands:
            - wget https://releases.hashicorp.com/terraform/${var.terraform_version}/terraform_${var.terraform_version}_linux_amd64.zip
            - unzip terraform_${var.terraform_version}_linux_amd64.zip
            - mv terraform /usr/local/bin/
        pre_build:
          commands:
            - terraform init
        build:
          commands:
            - terraform plan -out=tfplan
      artifacts:
        files:
          - tfplan
          - .terraform/**/*
          - '**/*'
    EOT
  }
}

resource "aws_codebuild_project" "terraform_apply" {
  name          = "${var.name_prefix}-terraform-apply"
  description   = "Apply Terraform changes"
  service_role  = aws_iam_role.terraform_codebuild_role.arn
  build_timeout = 10
  
  artifacts {
    type = "CODEPIPELINE"
  }
  
  environment {
    type                        = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:3.0"
    image_pull_credentials_type = "CODEBUILD"
  }
  
  source {
    type      = "CODEPIPELINE"
    buildspec = <<-EOT
      version: 0.2
      phases:
        install:
          runtime-versions:
            python: 3.8
          commands:
            - wget https://releases.hashicorp.com/terraform/${var.terraform_version}/terraform_${var.terraform_version}_linux_amd64.zip
            - unzip terraform_${var.terraform_version}_linux_amd64.zip
            - mv terraform /usr/local/bin/
        pre_build:
          commands:
            - terraform init
        build:
          commands:
            - terraform apply -auto-approve tfplan
    EOT
  }
}

resource "aws_iam_role" "terraform_codebuild_role" {
  name = "${var.name_prefix}-terraform-codebuild-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codebuild.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "terraform_codebuild_policy" {
  name = "${var.name_prefix}-terraform-codebuild-policy"
  role = aws_iam_role.terraform_codebuild_role.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject"
        ],
        Resource = [
          "${aws_s3_bucket.terraform_state.arn}/*",
          "${var.artifacts_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ],
        Resource = aws_dynamodb_table.terraform_locks.arn
      },
      {
        Effect = "Allow",
        Action = [
          "iam:*",
          "ec2:*",
          "ecs:*",
          "ecr:*",
          "elasticloadbalancing:*",
          "apigateway:*",
          "logs:*",
          "cloudwatch:*",
          "route53:*",
          "s3:*",
          "dynamodb:*",
          "codebuild:*",
          "codepipeline:*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_codepipeline" "terraform_pipeline" {
  name     = "${var.name_prefix}-terraform-pipeline"
  role_arn = aws_iam_role.terraform_codepipeline_role.arn
  
  artifact_store {
    location = var.artifacts_bucket
    type     = "S3"
  }
  
  stage {
    name = "Source"
    
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      
      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.terraform_repository_id
        BranchName       = var.terraform_branch_name
      }
    }
  }
  
  stage {
    name = "Plan"
    
    action {
      name             = "TerraformPlan"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["plan_output"]
      
      configuration = {
        ProjectName = aws_codebuild_project.terraform_plan.name
      }
    }
  }
  
  stage {
    name = "Approve"
    
    action {
      name     = "Approval"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }
  
  stage {
    name = "Apply"
    
    action {
      name            = "TerraformApply"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      version         = "1"
      input_artifacts = ["plan_output"]
      
      configuration = {
        ProjectName = aws_codebuild_project.terraform_apply.name
      }
    }
  }
}

resource "aws_iam_role" "terraform_codepipeline_role" {
  name = "${var.name_prefix}-terraform-codepipeline-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "codepipeline.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "terraform_codepipeline_policy" {
  name = "${var.name_prefix}-terraform-codepipeline-policy"
  role = aws_iam_role.terraform_codepipeline_role.id
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:GetBucketVersioning",
          "s3:PutObject"
        ],
        Resource = [
          var.artifacts_bucket_arn,
          "${var.artifacts_bucket_arn}/*"
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild"
        ],
        Resource = "*"
      },
      {
        Effect = "Allow",
        Action = [
          "codestar-connections:UseConnection"
        ],
        Resource = var.codestar_connection_arn
      }
    ]
  })
}