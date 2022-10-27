data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  user_data     = <<-EOF
    !#/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sudo ufw app list
    sudo ufw allow 'Nginx HTTP'
    sudo systemctl enable nginx
  EOF
  tags = {
    Name        = var.name
    Enviroment  = var.env
    Provisioner = "Terraform"
    Repo        = var.repo
  }
}
