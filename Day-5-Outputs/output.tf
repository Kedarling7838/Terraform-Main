output "az" {
  value = aws_instance.name.availability_zone
}
output "ip"{
    value = aws_instance.name.public_ip
}
output "privateip"{
    value=aws_instance.name.private_ip
    sensitive = true

}