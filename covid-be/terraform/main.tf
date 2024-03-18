provider "aws" {
  region = var.region
}

resource "aws_key_pair" "udemy-keypair" {
  key_name   = "udemy-keypair"
  public_key = file(var.public_key)
}

module "security" {
  source = "./modules/security"
  region = var.region
}
module "compute" {
  source                 = "./modules/compute"
  key_name               = aws_key_pair.udemy-keypair.key_name
  region                 = var.region
  instance_type          = var.instance_type
  ec2_security_group_ids = [module.security.public_security_group_id]
  ami_id                 = var.amis[var.region]
}
