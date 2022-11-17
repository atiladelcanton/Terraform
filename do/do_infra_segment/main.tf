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


resource "digitalocean_database_cluster" "postgres-server" {
  name       = var.database_name
  engine     = var.engine
  version    = var.version_database
  size       = var.size
  region     = var.region
  node_count = 1
  tags       = ["infra_sonar"]
}

resource "digitalocean_ssh_key" "ssh_windows" {
  name       = "ssh_windows"
  public_key = file("~/.ssh/id_rsa.pub")
}
resource "digitalocean_droplet" "sonar_server" {
  image      = var.image
  name       = var.droplet_name
  region     = var.region
  size       = var.size_droplet
  monitoring = true
  ipv6       = true
  ssh_keys   = [digitalocean_ssh_key.ssh_windows.fingerprint]
  tags       = ["infra_sonar"]
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
  # Verificar um registry de echo para entender o que está acontecendo
  provisioner "remote-exec" {
    inline = [
      "sysctl -w vm.max_map_count=524288",
      "sysctl -w fs.file-max=131072",
      "export HOST_DATABASE=${digitalocean_database_cluster.postgres-server.host}",
      "source ~/.bashrc",
      #start docker containers
      "cd /var &&  docker-compose up -d",
      #security
      "ufw allow 22",
      "ufw allow 88",
      "ufw allow 443",
      "ufw --force enable",
    ]
  }
}

