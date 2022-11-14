terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
variable "api_token" {
  default = "dop_v1_13268cec17b3db934f476a0274d8e1a36b87b11655b104675d0716874e03e15e"
}
variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.api_token
}

resource "digitalocean_ssh_key" "ssh_windows" {
  name = "ssh_windows"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "digitalocean_droplet" "web" {
  image      = "docker-20-04"
  name       = "sonar-server"
  region     = "nyc3"
  size       = "s-2vcpu-4gb"
  monitoring = true
  ipv6       = true
  ssh_keys   = [digitalocean_ssh_key.ssh_windows.fingerprint]
  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.pvt_key)
    timeout     = "2m"
  }
  provisioner "file" {
    source      = "docker-compose.yaml"
    destination = "/var/docker-compose.yaml"
  }
  provisioner "remote-exec" {
    inline = [
      #start docker containers
      "cd /var && docker-compose up -d",
      #security
      "ufw allow 22",
      "ufw allow 88",
      "ufw allow 443",
      "ufw --force enable",
    ]
  }
}

output "droplet_ip_address" {
  value = digitalocean_droplet.web.ipv4_address
}