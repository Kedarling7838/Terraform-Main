resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name = "new_key"
}

resource "aws_s3_bucket" "dependent" {
  bucket = "ytvhshfbbc"
}

# terraform apply -target=aws_s3_bucket.dependent
# terraform destroy -target=aws_s3_bucket.dependent