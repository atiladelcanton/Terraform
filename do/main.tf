terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
  }
}
variable "api_token" {
  default = "dop_v1_074e119dcac1d7b8b27009e571580da89c70c5e9fe4e5463e32c79d66a32f2ab"
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
  image      = "docker-20-04"
  name       = "sonar-server"
  region     = "nyc3"
  size       = "s-2vcpu-4gb"
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
  provisioner "file" {
    source      = "docker-compose.yaml"
    destination = "."
  }
  /*provisioner "remote-exec" {
    inline = [
      #start docker containers
      "docker volume create postgresql_data",
      "docker volume create sonarqube_data",
      "docker volume create sonarqube_extensions",
      "docker volume create sonarqube_logs",
      "docker volume create postgresql",

      "docker login --username atilarampazo --password kr3m0g3m4",
      "docker run --name sonarqubedb -p 5432:5432 -v pgdata:/var/lib/postgresql/data -e POSTGRES_USER=sonar -e POSTGRES_PASSWORD=sonar -d postgres",
      "docker run --link sonarqubedb:sonarqubedb --name sonarqube -p 9000:9000 -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL=jdbc:postgresql://sonarqubedb/sonar -d sonarqube",



      #security
      "ufw allow 22",
      "ufw allow 88",
      "ufw allow 443",
      "ufw --force enable",
    ]
  }*/
}
