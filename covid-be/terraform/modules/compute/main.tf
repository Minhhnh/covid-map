resource "aws_instance" "covid" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  tags = {
    "Name" = "Udemy Demo"
  }
  vpc_security_group_ids = var.ec2_security_group_ids
}
resource "aws_eip" "demo-eip" {
  instance = aws_instance.covid.id
  tags = {
    "Name" = "Demo elastic ip"
  }
}
