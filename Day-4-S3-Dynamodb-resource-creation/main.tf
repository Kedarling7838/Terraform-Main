# creating s3 bucket and dynamo DB for state backend storage and applying the lock mechanism for statefile

provider "aws" {
     region = "us-east-1"
}

resource "aws_s3_bucket" "example" {
  bucket = "dynamodbbucketkd"
}

resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name           = "terraform-state-lock-dynamo"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }
}