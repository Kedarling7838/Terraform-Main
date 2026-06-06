resource "aws_instance" "name" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  key_name ="new_key"
  tags= {
    Name ="terraform-instance"
  }

}