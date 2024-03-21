instance_type       = "t2.micro"
public_key          = "./keypair/udemy-key.pub"
region              = "ap-northeast-1"
availability_zone_1 = "ap-northeast-1c"
availability_zone_2 = "ap-northeast-1d"
cidr_block          = "10.0.0.0/16"
public_subnet_ips   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_ips  = ["10.0.10.0/24", "10.0.20.0/24"]
