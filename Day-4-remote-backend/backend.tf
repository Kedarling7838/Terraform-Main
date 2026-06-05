

terraform {
  backend "s3" {
    bucket         = "dynamodbbucketkd"
    region         = "us-east-1"
    key            = "terraform.tfstate"
    dynamodb_table = "terraform-state-lock-dynamo"
    encrypt        = true
  }
}
