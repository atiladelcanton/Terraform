
output "droplet_ip_address" {
   value = "http://${digitalocean_droplet.sonar_mentoria.ipv4_address}:9003/"
}