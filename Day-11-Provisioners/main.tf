# Define the AWS provider configuration.
provider "aws" {
  region = "us-east-1" # Replace with your desired AWS region.
}

resource "aws_key_pair" "example" {
  key_name   = "test" # Replace with your desired key name
  public_key = file("C:\\Users\\Asus\\.ssh\\test.pub")
}

# resource "aws_vpc" "myvpc" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "sub1" {
#   vpc_id = aws_vpc.myvpc.id
#
#   # Additional subnet configuration not visible in screenshot
# }

resource "aws_instance" "server" {
  ami                    = "ami-00e801948462f718a"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.example.key_name
#   vpc_security_group_ids = [aws_security_group.webSg.id]
#   subnet_id              = aws_subnet.sub1.id

  connection {
    type = "ssh"
    user = "ubuntu" # Replace with the appropriate username for your EC2 instance

    # private_key = file("C:/Users/veerababu/.ssh/id_rsa")
    private_key = file("C:/Users/Asus/.ssh/test")
    host        = self.public_ip
  }

  # local execution process
  provisioner "local-exec" {
    command = "touch file500"
  }

  # File provisioner to copy a file from local to the remote EC2 instance
  provisioner "file" {
    source      = "file10" # Replace with the path to your local file
    destination = "/home/ubuntu/file10" # Replace with the path on the remote instance
  }

  # remote execution process
  provisioner "remote-exec" {
    inline = [
      "touch file200",
      "echo hello from aws >> file200",
    ]
  }
}