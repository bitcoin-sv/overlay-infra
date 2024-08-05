terraform {
  backend "s3" {
    bucket         = "overlay-bucket"
    key            = "terraform/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform_locks"
    encrypt        = true
  }
}