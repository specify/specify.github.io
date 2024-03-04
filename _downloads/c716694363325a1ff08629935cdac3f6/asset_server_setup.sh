#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
sudo apt-get -y install --no-install-recommends \
  python3-venv \
  python3.8 \
  python3.8-dev \
  python3-pip \
  imagemagick \
  ghostscript \
  git \
  nginx \
  certbot \
  authbind \
  s3fs \
  awscli;

# python 3.6 install with apt
sudo apt install software-properties-common;
sudo add-apt-repository ppa:deadsnakes/ppa;
sudo apt update;
sudo apt install python3.6;
sudo apt-get install python3.6-distutils;

# install pip3.6
#wget https://bootstrap.pypa.io/pip/3.6/get-pip.py;
python3.6 -m venv --without-pip ve;
source ve/bin/activate;
wget https://bootstrap.pypa.io/get-pip.py;
#wget https://bootstrap.pypa.io/pip/3.5/get-pip.py

# activate python3.6 venv
sudo apt install python3-virtualenv;
python3.6 -m venv myenv;
source myenv/bin/activate;
pip install --no-cache-dir -r requirements.txt;

# TLS dependencies
sudo apt-get -y install --no-install-recommends \
	certbot \
	python3-certbot-nginx \
	software-properties-common;

# Import attachment files
#mkdir attachments;
#aws s3 cp s3://specify-cloud/assets-server/attachments/ ~/attachments --recursive;

# S3 Mounting
mkdir attachments;
s3fs specify-cloud /assets-server/attachments/;

# Clone asset server repo
git clone https://github.com/specify/web-asset-server.git;
cd ~/web-asset-server;
git checkout arm-build;

# Build python web asset server
python3.8 -m venv ve;
sudo ve/bin/pip install --no-cache-dir -r requirements.txt
#sudo pip install -r requirements.txt;

# Port config if needed
# not needed when running with nginx
#sudo apt-get install authbind;
#touch 80;
#chmod u+x 80;
#sudo mv 80 /etc/authbind/byport;

# Create SystemD service
sudo cat > /etc/systemd/system/web-asset-server.service << EOF
[Unit]
Description=Specify Web Asset Server
Wants=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/web-asset-server
ExecStart=/home/ubuntu/web-asset-server/ve/bin/python /home/ubuntu/web-asset-server/server.py
Restart=always

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl daemon-reload;
sudo systemctl enable web-asset-server.service;
sudo systemctl start web-asset-server.service;
sudo systemctl status web-asset-server.service;

# nginx
# sudo vim etc/nginx/sites-enabled/assets.conf
sudo rm -f /etc/nginx/sites-enabled/default;
sudo nginx -t;
sudo /etc/init.d/nginx reload;

# S3 Mounting
mount -o discard,defaults,noatime /dev/disk/by-id/scsi-0DO_Volume_volume-nyc1-01 /mnt/volume-nyc1-01

# Certbot TLS config
sudo mkdir /var/www/.well-known;
sudo certbot --nginx -d assets-test.specifycloud.org -d assets-test.specifycloud.org;
sudo ls -la /etc/letsencrypts/live/assets-test.specifycloud.org;
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096; #2048 or 1024
sudo openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 1024;
# add https server config to nginx assets.conf