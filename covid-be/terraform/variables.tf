variable "public_key" {
  type        = string
  default     = "./keypair/udemy-key.pub"
  description = "Public key path"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-northeast-1"
}

variable "amis" {
  type        = map(any)
  description = "AWS AMI depends on region"
  default = {
    "ap-northeast-1" : "ami-0eba6c58b7918d3a1"
    "ap-southeast-1" : "ami-06c4be2792f419b7b"
  }
}
