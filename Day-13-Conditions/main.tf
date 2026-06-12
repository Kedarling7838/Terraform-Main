# example s3 bucket creation condition based

provider "aws" {
  region = "us-east-1"
}

variable "create_bucket" {
  description = "Set to true to create the s3 bucket."
  type        = bool
  default     = true
}

resource "random_string" "suffix" {
  count   = var.create_bucket ? 1 : 0
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "example" {
  count = var.create_bucket ? 1 : 0

  bucket = "my-conditional-bucket-${random_string.suffix[count.index].id}"
  acl    = "private"

  tags = {
    Name        = "ConditionalBucket"
    Environment = "Dev"
  }
}

# variable "create_instance" {
#   description = "Set to true to create the EC2 instance."
#   type        = bool
#   default     = true
# }

# resource "aws_instance" "example" {
#   count         = var.create_instance ? 1 : 0
#   ami           = "ami-0440d3b780d96b29d" # Replace with a valid AMI ID
#   instance_type = "t2.micro"
#
#   tags = {
#     Name = "Condition-based-Instance"
#   }
# }

resource "aws_instance" "name" {
  ami               = "ami-085ad6ae776d8f09c"
  instance_type     = "t2.micro"
  key_name          = "ec2test"
  availability_zone = "us-east-1a"

  count = 2

  tags = {
    Name = "dev-${count.index}"
  }
}

############################ Example-2 Different names ############################

variable "env" {
  type    = list(string)
  default = ["dev", "test", "prod"]
}

resource "aws_instance" "name" {
  ami               = "ami-085ad6ae776d8f09c"
  instance_type     = "t2.micro"
  key_name          = "ec2test"
  availability_zone = "us-east-1a"

  count = length(var.env)

  tags = {
    Name = "dev-${count.index}"
  }
}

# Example-4: Numeric condition
# In this condition, if EC2 instance type == "t2.micro",
# only then the instance will be created.

# variables.tf

variable "ami" {
  type    = string
  default = "ami-0230bd60aa48260c6"
}

variable "instance_type" {
  type    = string
  default = "t2.nano"
}

# main.tf

resource "aws_instance" "dev" {
  ami           = var.ami
  instance_type = var.instance_type

  count = var.instance_type == "t2.micro" ? 1 : 0

  tags = {
    Name = "dev_server"
  }
}