#Creating VPC
resource "aws_vpc" "prod" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "prod_vpc"
  }
}

#creating subnet
resource "aws_subnet" "prod" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name="public_subnet"
  }
}

#Creating Internet Getway
resource "aws_internet_gateway" "prod" {
  vpc_id = aws_vpc.prod.id
  tags = {
    Name="prod_ig"
  }
}

#create Route Table and Edit Rotes
resource "aws_route_table" "prod" {
   vpc_id = aws_vpc.prod.id
   route {
    gateway_id = aws_internet_gateway.prod.id
    cidr_block = "0.0.0.0/0"
   }
}
#Subnet Association
resource "aws_route_table_association" "prod" {
  route_table_id = aws_route_table.prod.id
  subnet_id = aws_subnet.prod.id
}

# creating security group
resource "aws_security_group" "allow_tls" {
  name = "allow_tls"
  description = "Allow TLS inbound rules"
  vpc_id = aws_vpc.prod.id


ingress {
    description = "TLS for ssh"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
ingress {
    description = "TLS for http"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
}
}

#creation of server
resource "aws_instance" "prod" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  key_name ="new_key"
  subnet_id = aws_subnet.prod.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  tags= {
    Name ="terraform-instance"
  }
}
