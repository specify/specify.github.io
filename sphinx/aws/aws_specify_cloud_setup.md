# Specify Cloud Setup

## Setup Aurora MySQL Database
TODO

## Setup EC2 Server
EC2 Parameters:
- ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-20220131  
ami-0770bf1d6ae61c858 

## Initial Commands
```bash
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
```

## SSH Configuration

* Client

  * config file: ~/.ssh/config
	```
	Host *
		ServerAliveInterval 20
		#TCPKeepAlive no
	```

* Server

  * config file: /etc/ssh/sshd_config
	```
	ClientAliveInterval 1200
	ClientAliveCountMax 3
	```
  * Then run `sudo systemctl reload sshd`

## Config files
spcloudservers.json ->
```json
{
	"servers": {
		"freshfish": {
			"sp7": "edge",
			"sp6": "specify6803",
			"https": false,
			"env": {
                "ASSET_SERVER_URL": "https://demo-assets.specifycloud.org/web_asset_store.xml",
                "ANONYMOUS_USER": "sp7demofish"
            }
		}
	},
	"decommissioned": [],
	"sp6versions": {
		"specify6800": "6.8.00",
		"specify6801": "6.8.01",
		"specify6802": "6.8.02",
		"specify6803": "6.8.03"
	}
}
```
defaults.env ->
```
DATABASE_HOST=specifycloud-dev-database-1-instance-1.cqvncffkwz9t.us-east-1.rds.amazonaws.com
DATABASE_PORT=3306
MASTER_NAME=master
MASTER_PASSWORD=mastermaster
SECRET_KEY=bogus
ASSET_SERVER_URL=https://assets1.specifycloud.org/web_asset_store.xml
ASSET_SERVER_KEY=tnhercbrhtktanehul.dukb
REPORT_RUNNER_HOST=10.132.218.32
REPORT_RUNNER_PORT=8080
CELERY_BROKER_URL=redis://redis/0
CELERY_RESULT_BACKEND=redis://redis/1
LOG_LEVEL=WARNING
SP7_DEBUG=false
```


## Info Misc.

### aws credentials:
- username: `specify.user`
- password: SPECIFY_USER_PASSWORD
- access key: ACCESS_KEY
- secret access key: ACCESS_KEY_SECRET
- default region: us-east-1
- default output format: json

### AWS EC2 User data:
```bash
# Avoid services restarting during apt upgrade
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf;
sudo sed -i "s/#\$nrconf{restart} = 'i';/\$nrconf{restart} = 'a';/g" /etc/needrestart/needrestart.conf;

# Run apt installs
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y apt-transport-https ca-certificates git gh curl software-properties-common wget python3-pip awscli mysql-client j2cli;

# Configure AWS
aws configure set aws_access_key_id "ACCESS_KEY";
aws configure set aws_secret_access_key "ACCESS_KEY_SECRET";
aws configure set default.region us-east-1;
aws configure set default.output json;

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
sudo apt update;
apt-cache policy docker-ce;
sudo apt install -y docker-ce;
docker --version;

# Install docker compose
mkdir .docker;
mkdir .docker/cli-plugins;
curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose;
chmod +x ~/.docker/cli-plugins/docker-compose;
docker compose version;

# Python setup
# python3 -m pip install j2cli;
# export PATH=$PATH:/home/ubuntu/.local/bin;
# sudo apt install j2cli;

# Copy files from S3
aws s3 cp s3://specify-cloud/repo-snapshots/docker-compositions/ ./ --recursive;
aws s3 cp s3://specify-cloud/repo-snapshots/spcloudservers.json ./specifycloud/;
aws s3 cp s3://specify-cloud/repo-snapshots/defaults.env ./specifycloud/;

# Database setup
mkdir seed-databases;
aws s3 cp s3://specify-cloud/seed-database/specify.sql ./seed-databases/;
mysql --host specify-cloud-swiss-demo-database-1.c9qlnkmf2lfl.eu-central-2.rds.amazonaws.com --port 3306 -u master -p'mastermaster' -e "create database specify;";
mysql --host specify-cloud-swiss-demo-database-1.c9qlnkmf2lfl.eu-central-2.rds.amazonaws.com --port 3306 -u master -p'mastermaster' specify < ./seed-databases/specify.sql;
rm -f ./seed-databases/specify.sql;

# Configure Specify Network
cd specifycloud;
touch spcloudservers.json;
touch defaults.env;

# Run Specify Network
make;
sudo docker compose up -d;

# Certbot setup
sudo apt install certbot python3-certbot-apache;
sudo mkdir /var/www/sp7demofish;

# Github clone private repo
ssh-keygen -t ed25519 -C "acwhite211@gmail.com";
#ssh-keygen -t rsa -b 4096 -C "acwhite211@gmail.com";

# git clone repos
git clone https://github.com/specify/specify7.git;
git clone https://github.com/specify/specify6.git;
git clone https://github.com/specify/report-runner-service.git;
#git clone https://github.com/specify/web-asset-server.git;

# Install nginx
sudo apt install -y nginx openjdk-8-jdk maven ant;
sudo ufw allow 'Nginx HTTP';
sudo ufw status;
sudo update-alternatives --set java /usr/lib/jvm/java-8-openjdk-arm64/jre/bin/java;

# Build without docker
cd specify6;
ant compile-nonmac;
```

###  AWS Pricing

Database Prices:
- db.r5.large - 2 vCPUs - 16 gb ram - $0.24 per hour = $173.00 per month
- db.m5.large - 4vCPUs - 16 gb ram - $0.171 per hour = $123.10 per month
- db.t3.medium - 2vCPUs - 4 gb ram - $0.068 per hour = $49.00 per month
- db.t3.large - 2vCPUs - 8 gb ram - $0.136 per hour = $97.92 per month
- db.t3.xlarge - 4vCPUs - 16 gb ram - $0.272 per hour = $195.80 per month
- +db.t4g.medium - 2vCPUs - 4 gb ram - $0.065 per hour = $46.80 per month
- db.t4g.large - 2vCPUs - 8 gb ram - $0.129 per hour = $92.88 per month

Aurora v2 Prices:
- 1 ACU - 2 vCPUs - 2 gb ram - $0.12 per ACU hour = $86.40 per ACU month

Aurora v1 Prices:
- 1 ACU - 2 vCPUs - 2 gb ram - $0.06 per ACU hour = $43.29 per ACU month

EC2 Prices:
- t4g.nano - 2vCPUs - 0.5 gb ram - $0.0042 per hour = $3.02 per month
- t4g.micro - 2vCPUs - 1 gb ram - $0.0084 per hour = $6.05 per month
- t4g.small - 2vCPUs - 2 gb ram - $0.0168 per hour = $12.10 per month
- +t4g.medium - 2vCPUs - 4 gb ram - $0.0336 per hour = $24.19 per month
- t4g.large - 2vCPUs - 8 gb ram - $0.0672 per hour = $48.38 per month
- t4g.xlarge - 4vCPUs - 16 gb ram - $0.1344 per hour = $96.77 per month
- m7g.medium - 1vCPUs - 4 gb ram - $0.0408 per hour = $29.38 per month
- m7g.large - 2vCPUs - 8 gb ram - $0.0816 per hour = $58.75 per month
- m7g.xlarge - 4vCPUs - 16 gb ram - $0.2232 per hour = $160.70 per month

Fargate Prices (Linux/ARM):
- On Demand - $0.03238 per vCPU per hour and $0.00356 per GB per hour
- Spot - $0.01279585 per vCPU per hour and $0.00140508 per GB per hour
- Ephemeral Storage - $0.000111 per storage GB per hour
- 1 On-Demand vCPU = $23.31 per month
- 1 On-Demand GB ram = $2.56 per month
- 0.25 On-Demand vCPU & 0.5 GB ram On-Demand  = 5.82 + 1.28 = $7.10 per month
- 1 Spot vCPU = $9.21 per month
- 1 Spot GB ram = $1.01 per month
- 1 On-Demand with Savings Plan vCPU = $12.59 per month
- 1 On-Demand with Savings Plan GB ram = $1.38 per month
- ex. 1 cpu and 1 gb = $10.22 per month
- ex. 2 cpus and 8 gb = $26.52 per month
- ex. 8 cpus and 16 gb = $89.89 per month
- ex. 16 cpus and 32 gb = $179.78 per month

Notes:
- m7g is general purpose using graviton 3
- t4g is general purpose using graviton 2
- for Fargate, memory and storage are cheep, it's the vCPUs that get expensive

NA Server:
- 45 clients * 2 = 90 django containers
- digital ocean 4vCPUs 8 GB memory
	- cpu usage nominal at 25% with spikes to 40%
	- memory usage nominal at 90%
- 45 / 0.25 vCPU = 11.25
- 45 * 0.5 GB = 22.5
- 10 containers per task definition
- So 9 task definitions needed for django
- vimsfish might need more than 0.5 GB

CA Server:
- 8 clients
- digital ocean 1vCPUs 2 GB memory
	- cpu usage nominal at 8% with spikes to 80%
	- memory usage nominal at 85%
- beaty might need more than 0.5 GB

EU Server:
- 9 clients
- digital ocean 1vCPUs 2 GB memory
	- cpu usage nominal at 6% with spikes to 72%
	- memory usage nominal at 80%
- herb_rbge might need more than 0.5 GB

So maybe 1vCPU and 0.5 GB of memory will be enough to handle each django container.  
Most are fine with 0.5 GB, only a few will go over with the django and worker containers 
combined.

Price Option Comparison
t4g.medium
- on-demand
- spot
- 12 month reserved instance
- 36 month reserved instance


### Specify Network Extract

Specify Network EC2 instance:
```bash
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y wget awscli unzip;
aws configure set aws_access_key_id "ACCESS_KEY";
aws configure set aws_secret_access_key "ACCESS_KEY_SECRET";
aws configure set default.region us-east-1;
aws configure set default.output json;
mkdir gbif;
mkdir gbif/download;
mkdir gbif/extract;
cd gbif/download;
aws s3 cp s3://specify-network/gbif/0146304-230224095556074.zip ./;
wget $GBIF_URL;
unzip 0146304-230224095556074.zip -d ../extract/;
cd ../extract/;
mv ./0146304-230224095556074.csv ./gbif.csv
aws s3 cp gbif.csv s3://specify-network-dev/gbif_test/gbif_extract/;
```

specify aws github ssh key:
id_ed25519.pub ->
```
sh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKHq3lVhZ4U8j0Derpm37wgUPLGLgQtim77M68m+XNWL acwhite211@gmail.com
```
id_ed25519 ->
```
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
QyNTUxOQAAACCh6t5VYWeFPI9A3q6Zt+8IFDyxi4ELYpu+zOvJvlzViwAAAJj4E1iO+BNY
jgAAAAtzc2gtZWQyNTUxOQAAACCh6t5VYWeFPI9A3q6Zt+8IFDyxi4ELYpu+zOvJvlzViw
AAAEDi0KTenAzeyomMyaqOBd8APyQjcL3YU7tXMMMrit8bjaHq3lVhZ4U8j0Derpm37wgU
PLGLgQtim77M68m+XNWLAAAAFGFjd2hpdGUyMTFAZ21haWwuY29tAQ==
-----END OPENSSH PRIVATE KEY-----
```

MariaDB version: 10.3.38-MariaDB-0ubuntu0.20.04.1-log
AWS DB password: DB_PASSWORD

### Install Ubuntu EC2 instance with no docker
```bash
#!/bin/bash

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
aws s3 cp s3://specify-cloud/seed-database/sp7demofish.sql ./specify7/seed-database/;

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
```

### Using the Amazon arm54 centos image:
```bash
#!/bin/bash

sudo yum upgrade;
sudo yum install -y \
	git gcc \
	openldap-devel \
	#mariadb-devel \
	mariadb105-devel.aarch64 \
	nodjs npm \
	#java-11-openjdk-headless \
	#java-11-amazon-corretto-headless.aarch64 \
	java-1.8.0-amazon-corretto.aarch64 java-1.8.0-amazon-corretto-devel.aarch64 \
	#python38-virtualenv \
	#python38 python38u-devel \
	redis6 unzip
sudo dnf install mariadb105;
sudo dnf install openldap-servers;

# Specify 7
python3 -m venv specify7/ve;
specify7/ve/bin/python3 -m pip install --upgrade pip;
specify7/ve/bin/pip install wheel;
specify7/ve/bin/pip install --upgrade -r specify7/requirements.txt
```
