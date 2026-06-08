variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
  default     = ""
}

variable "type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = ""
}

variable "key" {
  description = "The name of the key pair for the EC2 instance"
  type        = string
  default     = ""
}

variable "region" {
  description = "The AWS region where the EC2 instance will be created"
  type        = string
  default     = ""
}