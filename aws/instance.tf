provider "aws" {
 region  = "us-east-1"
 profile = "linux"
}
 resource "aws_key_pair" "deployer" {
    key_name = "deployer_linux"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
 }
 
resource "aws_instance" "teste2" {
 ami = "ami-09d3b3274b6c5d4aa"
 instance_type = "t2.micro"
 key_name = aws_key_pair.deployer.key_name
 tags = {
    Name: "Terraform"
 }
}