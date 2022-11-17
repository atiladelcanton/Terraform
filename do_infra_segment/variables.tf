variable "database_name" {
  type    = string
  default = "sonar-server-db"
}
variable "region" {
  default = "nyc3"
}
variable "engine" {
  default = "pg"
}
variable "version_database" {
  default = "14"
}
variable "size" {
  default = "db-s-1vcpu-2gb"
}
variable "api_token" {
  default = ""
}
variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "droplet_name" {
  type    = string
  default = "sonar-server-mentoria"
}

variable "size_droplet" {
  default = "s-2vcpu-4gb"
}
variable "ssh_user" {
  default = "root"
}
variable "image" { default = "docker-20-04" }
