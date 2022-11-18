variable "droplet_name" {
  type    = string
  default = "sonar-server-mentoria-call"
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
  default = ""
}
variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}
variable "ssh_key_name" {
  default = "Ubunto Empresa"
}

variable "image_name"{
  default = "docker-20-04"
}
