terraform {
  backend "s3" {
    bucket = "subscription-testing-terraform-tf"
    key = "ecs/subscription/terraform.tfstate"
    region = "us-west-2"
    encrypt = true
    dynamodb_table = "subscription-terraform-locking"
  }
}