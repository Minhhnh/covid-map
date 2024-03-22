resource "aws_instance" "covid" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.ec2_security_group_ids
  subnet_id              = var.subnet_id
  tags = {
    "Name" = "Covid Map"
  }
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }
  user_data = <<EOF
    #!/bin/bash
    sudo apt update
    sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable" -y
    sudo apt install docker-ce -y 
    sudo usermod -aG docker ubuntu

    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    
    sudo reboot
  EOF
}
resource "aws_eip" "demo-eip" {
  instance = aws_instance.covid.id
  tags = {
    "Name" = "ec2 instance eip"
  }
}
