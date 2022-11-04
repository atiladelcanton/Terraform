terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
variable "api_token" {
  default = "dop_v1_c7de7dfe07942616cd3a074ab7edfa91de66bde098af4266385a4672298bd93c"
}
variable "pvt_key" {
  default = "/home/atila.rampazo/.ssh/id_rsa"
}
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.api_token
}

data "digitalocean_ssh_key" "terraform" {
  name = "Ubunto Empresa"
}
resource "digitalocean_droplet" "web" {
  image      = "ubuntu-22-10-x64"
  name       = "web-1"
  region     = "nyc3"
  size       = "s-1vcpu-1gb"
  monitoring = true
  ipv6       = true
  ssh_keys   = [data.digitalocean_ssh_key.terraform.fingerprint]
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo apt-get update -y",
      "sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y",
      "sudo apt install apt-transport-https ca-certificates curl software-properties-common -y",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -",
      "sudo add-apt-repository deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable",
      "apt-cache policy docker-ce",
      "sudo apt install docker-ce",
      "sudo systemctl status docker",
      "sudo usermod -aG docker ${USER}",
      "su - ${USER}",
      "sudo usermod -aG docker username"
    ]
  }
}
