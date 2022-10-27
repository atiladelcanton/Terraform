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
    apt-get update
    apt-get install apache2 -y
    systemctl start apache2
    systemctl enable apache2
    echo -e "<h1> Deployed by Terraform</h1><p>You're on host: $(hostname)" > /var/www/html/index.html
  EOF
  tags = {
    Name        = var.name
    Enviroment  = var.env
    Provisioner = "Terraform"
    Repo        = var.repo
  }
}
