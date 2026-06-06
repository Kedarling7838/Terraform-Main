data "aws_subnet" "selected"{
    filter{
        name="tag:Name"
        values = ["subnet1"]
    }
}

data "aws_security_group" "selected" {
    filter {
        name = "tag:Name"
        values = ["test"]
    }
}

resource "aws_instance" "name" {
  ami = "ami-00e801948462f718a"
  instance_type = "t3.micro"
  key_name ="new_key"
  subnet_id =data.aws_subnet.selected.id
  vpc_security_group_ids = [data.aws_security_group.selected.id]
  tags= {
    Name ="terraform-instance"
  }
}