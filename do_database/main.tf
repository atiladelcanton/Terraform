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
  tags = ["mentoria"]
}

output "ip_db_output" {
  value = digitalocean_database_cluster.postgres-server.id
}
output "port_db_output" {
  value = digitalocean_database_cluster.postgres-server.port
}
output "user_db_output" {
  value = digitalocean_database_cluster.postgres-server.user
}
output "password_db_output" {
  value = digitalocean_database_cluster.postgres-server.password
  sensitive = true
}
output "host_db_output" {
  value = digitalocean_database_cluster.postgres-server.host
}
