# creating s3 bucket and dynamo DB for state backend storage
# and applying the lock mechanism for statefile

resource "aws_s3_bucket" "example" {
  bucket = "kds3bucketpractice"
}

resource "aws_instance" "dev" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  key_name ="new_key"
  tags= {
    Name ="terraform-instance"
  }
  depends_on = [aws_s3_bucket.example]
}