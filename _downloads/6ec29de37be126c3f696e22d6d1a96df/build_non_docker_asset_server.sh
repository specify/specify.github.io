#!/bin/bash

## Set these environment variables before running the script
# export DOMAIN_NAME <domain name>
# export SUBDOMAIN_PREFIX <first section of subdomain>

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

# python 3.6
#sudo apt update
#sudo apt install build-essential checkinstall zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libreadline-dev libffi-dev libsqlite3-dev wget libbz2-dev;
#wget https://www.python.org/ftp/python/3.6.15/Python-3.6.15.tgz;
#tar -xf Python-3.6.15.tgz;
#cd Python-3.6.15 && ./configure --enable-optimizations;
#make -j$(nproc);
#sudo make altinstall;
#python3.6 --version;

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
#deactivate;

# activate python3.6 venv
sudo apt install -y python3-virtualenv;
python3.6 -m venv myenv;
source myenv/bin/activate;
pip install --no-cache-dir -r requirements.txt;
#deactivate;

# TLS dependencies
sudo apt-get -y install --no-install-recommends \
	certbot \
	python3-certbot-nginx \
	software-properties-common;

# Configure AWS
aws configure set aws_access_key_id "ACCESS_KEY";
aws configure set aws_secret_access_key "ACCESS_KEY_SECRET";
aws configure set default.region us-east-1;
aws configure set default.output json;

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

# Port config
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

# TODO: EFS Mounting

sudo ls -la /etc/letsencrypt/live/$SUBDOMAIN_PREFIX.$DOMAIN_NAME;
# Certbot TLS config
sudo mkdir /var/www/.well-known;
sudo certbot --nginx -d $SUBDOMAIN_PREFIX.$DOMAIN_NAME -d $SUBDOMAIN_PREFIX.$DOMAIN_NAME;
sudo ls -la /etc/letsencrypt/live/$SUBDOMAIN_PREFIX.$DOMAIN_NAME;
#openssl dhparam -out /etc/nginx/dhparam.pem 4096;
sudo openssl dhparam -out /etc/ssl/certs/dhparam.pem 4096; #2048 or 1024
sudo openssl dhparam -dsaparam -out /etc/ssl/certs/dhparam.pem 1024;
# add https server config to nginx assets.

# Edit