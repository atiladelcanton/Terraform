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
  default = "dop_v1_cf39993e9dd2fa93ab31b7531c6a604fd2371469ff8994567d1074ebe82e6ece"
}
variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}