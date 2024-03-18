output "public_ip_address" {
  value = module.compute.ec2_ip_address_public
}
output "private_ip_address" {
  value = module.compute.ec2_ip_address_private
}
output "public_security_group_id" {
  value = module.security.public_security_group_id
}
output "private_security_group_id" {
  value = module.security.public_security_group_id
}
