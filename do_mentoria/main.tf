terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.api_token
}

resource "digitalocean_ssh_key" "ssh_windows" {
  name = "ssh_windows"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "digitalocean_droplet" "sonar_mentoria" {
  image      = "docker-20-04"
  name       = var.droplet_name
  region     = var.region
  size       = var.size
  monitoring = true
  ipv6       = true
  ssh_keys   = [digitalocean_ssh_key.ssh_windows.fingerprint]
  tags = [ "mentoria" ]
  connection {
    host        = self.ipv4_address
    user        = var.ssh_user
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
      "sysctl -w vm.max_map_count=524288",
      "sysctl -w fs.file-max=131072",
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
