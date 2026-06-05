terraform {
  backend "s3" {
    bucket = "mykds3bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
