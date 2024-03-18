output "ec2_ip_address_public" {
  value = aws_eip.demo-eip.public_ip
}
output "ec2_ip_address_private" {
  value = aws_instance.covid.private_ip
}
