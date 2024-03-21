variable "instance_type" {
  type        = string
  description = "AWS instance type"
}
variable "key_name" {
  type        = string
  description = "AWS key name"
  nullable    = false
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "ami_id" {
  type        = string
  description = "AWS AMI depends on region"
  nullable    = false
}
variable "ec2_security_group_ids" {
  type     = list(string)
  nullable = false
}
variable "subnet_id" {
  type        = string
  description = "The subnet ID to launch in"
  nullable    = false
}
