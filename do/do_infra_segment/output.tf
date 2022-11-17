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
output "database_name"{
  value = digitalocean_database_cluster.postgres-server.name
}

output "droplet_ip_address" {
   value = "https://${digitalocean_droplet.sonar_server.ipv4_address}:9003/"
}