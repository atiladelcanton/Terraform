variable "region" {
  description = "Define what region the instance will be deployed"
  default     = "us-east-1"
}

variable "name" {
  description = "Name of the application"
  default     = "server01"

}

variable "env" {
  description = "Environment of the application"
  default     = "dev"
}

variable "ami" {
  description = "Aws AMI to be used"
  default     = "ami-0149b2da6ceec4bb0"
}

variable "instance_type" {
  description = "AWS Instance type defines the hardware configuration of the machine"
  default     = "t2.micro"
}

variable "repo" {
  description = "Repository of the application"
  default     = "github.com/atiladelcanton/sonar-docker"
}
