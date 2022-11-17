variable "database_name" {
  type    = string
  default = "sonar-server-db"
}
variable "region" {
  default = "nyc1"
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
