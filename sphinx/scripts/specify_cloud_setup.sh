#!/bin/bash

sudo apt-get update;
sudo apt upgrade;
sudo apt install -y make python3-pip

#sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose mysql-client;
#sudo apt install docker.io

# Install Docker
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common;
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
sudo apt update;
sudo apt -y install docker-ce;
docker --version;
sudo systemctl status docker;

#sudo systemctl start docker.service
#sudo systemctl enable docker.service
#sudo systemctl status docker.service

# Install docker compose
mkdir .docker
mkdir .docker/cli-plugins
curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose;
chmod +x ~/.docker/cli-plugins/docker-compose;
docker compose version;

# Install awscli
sudo apt -y install awscli;
aws configure; # See aws credentials at bottom of notes

# Setup mysql datbase connection
sudo apt install -y mysql-client;

# Copy files from S3
aws s3 cp s3://specify-cloud/repo-snapshots/docker-compositions/ ./ --recursive

# python setup
sudo apt install -y python3-pip;
python3 -m pip install j2cli;

# Create config files for specifycloud
cd specifycloud;
vim spcloudservers.json
vim defaults.env
sudo apt install j2cli
make

# ssh client-server alive settings
sudo echo -e "ClientAliveInterval 1200\nClientAliveCountMax 3" >> /etc/ssh/sshd_config
sudo systemctl reload sshd;

#docker pull specifyconsortium/specify7-service:edge

# su specify -c make
docker-compose up -d
