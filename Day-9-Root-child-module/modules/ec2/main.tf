resource "aws_instance" "this" {
  ami           = "ami-0c55b159cbfafe1f0"  # Replace with a valid AMI
  instance_type = var.instance_type

  tags = {
    Name = "Terraform-EC2"
  }
}