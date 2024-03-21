provider "aws" {
  region = var.region
}

resource "aws_key_pair" "udemy-keypair" {
  key_name   = "udemy-keypair"
  public_key = file(var.public_key)
}
module "networking" {
  source              = "./modules/networking"
  region              = var.region
  cidr_block          = var.cidr_block
  public_subnet_ips   = var.public_subnet_ips
  private_subnet_ips  = var.private_subnet_ips
  availability_zone_1 = var.availability_zone_1
  availability_zone_2 = var.availability_zone_2
}
module "security" {
  source = "./modules/security"
  region = var.region
  vpc_id = module.networking.vpc_id
}
module "compute" {
  source                 = "./modules/compute"
  key_name               = aws_key_pair.udemy-keypair.key_name
  region                 = var.region
  instance_type          = var.instance_type
  ec2_security_group_ids = [module.security.public_security_group_id]
  ami_id                 = var.amis[var.region]
  subnet_id              = module.networking.public_subnet_ids[0]
}
