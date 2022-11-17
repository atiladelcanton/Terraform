variable "droplet_name" {
  type    = string
  default = "sonar-server-mentoria"
}
variable "region" {
  default = "nyc3"
}
variable "size" {
  default = "s-2vcpu-4gb"
}
variable "ssh_user" {
  default = "root"
}
variable "api_token" {
  default = "dop_v1_cf39993e9dd2fa93ab31b7531c6a604fd2371469ff8994567d1074ebe82e6ece"
}
variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}
