resource "aws_instance" "covid" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  subnet_id              = var.subnet_id
  tags = {
    "Name" = "Udemy Demo"
  }
}
resource "aws_eip" "demo-eip" {
  instance = aws_instance.covid.id
  tags = {
    "Name" = "Demo elastic ip"
  }
}
