variable "region" {
  type     = string
  nullable = false
}
variable "cidr_block" {
  type     = string
  nullable = false
}
variable "public_subnet_ips" {
  type     = list(string)
  nullable = false
}
variable "private_subnet_ips" {
  type     = list(string)
  nullable = false
}
variable "availability_zone_1" {
  description = "Availability zone for first subnet"
  nullable    = false
}
variable "availability_zone_2" {
  description = "Availability zone for second subnet"
  nullable    = false
}
