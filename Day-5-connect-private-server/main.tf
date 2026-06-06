# Create vpc
resource "aws_vpc" "prod"{
    cidr_block="10.0.0.0/16"
    tags = {
        Name = "Custom_VPC"
    }
}

#creating public subnet
resource "aws_subnet" "prod" {
  vpc_id = aws_vpc.prod.id
  cidr_block = "10.0.0.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name="public_subnet"
  }
}

# Creating private subnet
resource "aws_subnet" "private" {
    vpc_id = aws_vpc.prod.id
    cidr_block = "10.0.1.0/24"
    tags = {
        Name = "prod-private"
    }
}
# creating internet gateway
resource "aws_internet_gateway" "prod" {
    vpc_id = aws_vpc.prod.id
    tags = {
        Name = "prod-internet-gateway"
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




# NAT GATEWAY REAOURCE CREATION
# 1. Allocate Elastic IP for the NAT Gateway
resource "aws_eip" "prod" {
  domain = "vpc"

  tags = {
    Name = "main-nat-eip"
  }
}

# 2. Create the NAT Gateway
resource "aws_nat_gateway" "prod" {
  allocation_id = aws_eip.prod.id
  subnet_id     = aws_subnet.prod.id # Must be a public subnet

  tags = {
    Name = "main-nat-gateway"
  }

  # Recommended: Explicitly depend on the Internet Gateway for the VPC
  depends_on = [aws_internet_gateway.prod]
}

# 3. Create a Route Table for Private Subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.prod.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.prod.id
  }

  tags = {
    Name = "private-route-table"
  }
}

# 4. Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Creating Security Group
resource "aws_security_group" "prod" {
  name        = "prod-security-group"
  description = "Security group for production instances"
  vpc_id      = aws_vpc.prod.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress{
    from_port =80
    to_port =80
    protocol="tcp"
    cidr_blocks =["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create Public Server
resource "aws_instance" "public_server"{
    ami="ami-00e801948462f718a"
    instance_type="t3.micro"
    subnet_id=aws_subnet.prod.id
    vpc_security_group_ids=[aws_security_group.prod.id]
    key_name="new_key"
    tags={
        Name="Public_Server"
    }
}

# Create Private Server
resource "aws_instance" "private_server" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.prod.id]
  key_name = "new_key"
  tags = {
    Name = "Private_Server"
  }
}