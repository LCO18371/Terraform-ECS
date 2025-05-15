# Terraform-ECS
Creation of resources using terraform dummy flow
## Steps to Set Up Terraform for ECS

### 1. Create a Folder Structure
Start by organizing your Terraform project. Below is an example folder structure:

```
microservice-ecs-fargate/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── backend.tf
│   └── modules/
│       ├── network/             # VPC, Subnets, IGW, Route Tables
│       ├── ecs/                 # Cluster, Task Definition, Service
│       ├── ecr/                 # ECR Repo
│       └── lb/                  # NLB, Target Group
├── microservice/
│   ├── Dockerfile
│   ├── app/
│   └── buildspec.yml           # or GitHub Actions workflow
├── cloudformation/
│   └── task-def.yaml           # If CFN is used for task def
└── ci-cd/
    └── github-actions.yml      # or codepipeline.yml / jenkinsfile

```
