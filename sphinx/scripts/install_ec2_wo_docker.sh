#!/bin/bash

# Replace the following variable before running this script:
# $BUCKET_NAME

# Avoid services restarting during apt upgrade
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf;
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf;

# Run apt installs
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y --no-install-recommends \
	apt-transport-https ca-certificates git curl software-properties-common wget \
	python3-pip awscli mysql-client j2cli nginx openjdk-8-jdk maven ant gcc make \
	openldap-devel \
	#nodejs npm \
	python3-venv \
	#python3.8 python3.8-dev \
	redis unzip \
	apache2 \
	libapache2-mod-wsgi-py3;

# Install nodejs 18
cd ~;
#curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh;
#sudo bash nodesource_setup.sh;
#sudo apt install -y nodejs;
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
source ~/.bashrc;
nvm install v18;
nvm use 18;
nvm alias default 18;
node -v;

# Install python 3.8
sudo add-apt-repository -y ppa:deadsnakes/ppa;
sudo apt update;
sudo apt install -y python3.8 python3.8-dev;

# Git clone repos
git clone https://github.com/specify/specify7.git;
git clone https://github.com/specify/specify6.git;
git clone https://github.com/specify/report-runner-service.git;

# Setup database
aws s3 cp s3://$BUCKET_NAME/seed-database/sp7demofish.sql ./specify7/seed-database/;

# Setup specify6
#cd ~/specify6;
#sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-arm64/jre/bin/java;
#wget https://update.specifysoftware.org/6803/Specify_unix_64.sh;
#sh Specify_unix_64.sh -q -dir ./Specify6.8.03;
#sudo ln -s $(pwd)/Specify6.8.03 /opt/Specify;
sudo ln -s $(pwd)/specify6 /opt/Specify;

# Setup specify7
cd ~/specify7;
#git checkout tags/v7.8.10
python3.8 -m venv specify7/ve;
specify7/ve/bin/pip install wheel;
specify7/ve/bin/pip install --upgrade -r specify7/requirements.txt;

# Run specify dev
cd ~/specify7;
source ve/bin/activate;
make runserver;

# Setup specify-worker
cd ~/specify7;
#ve/bin/celery -A specifyweb worker -l INFO --concurrency=1 -Q specify;
celery -A specifyweb worker -l INFO --concurrency=1;

# Setup apache
# sudo apt install -y apache2 libapache2-mod-wsgi-py3

# Setup nginx
#sudo apt install -y nginx openjdk-8-jdk maven ant;
sudo ufw allow 'Nginx HTTP';
sudo ufw status;
