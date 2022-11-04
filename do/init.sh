!#/bin/bash

sudo apt-get update -y;
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y;
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
sudo usermod -aG docker ${USER}
su - ${USER}
sudo usermod -aG docker username