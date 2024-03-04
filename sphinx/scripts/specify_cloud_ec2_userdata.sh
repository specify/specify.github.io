# Make sure to fill in all variables (starting with `$`) in the following userdata
# script before including it in an EC2 launch configuration.
#
#  $BUCKET_NAME
#  $DATABASE_NAME
#  $DB_IDENTIFIER
#  $REGION
#  $MASTER_PASSWORD

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
aws configure set default.region REGION;
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

# Copy files from S3 specify cloud bucket
aws s3 cp s3://$BUCKET_NAME/repo-snapshots/docker-compositions/ ./ --recursive;
aws s3 cp s3://$BUCKET_NAME/repo-snapshots/spcloudservers.json ./specifycloud/;
aws s3 cp s3://$BUCKET_NAME/repo-snapshots/defaults.env ./specifycloud/;

# Database setup
mkdir seed-databases;
aws s3 cp s3://$BUCKET_NAME/seed-database/specify.sql ./seed-databases/;
mysql --host $DATABASE_NAME.$DB_IDENTIFIER.$REGION.rds.amazonaws.com --port 3306 \
	  -u master -p$MASTER_PASSWORD -e "create database specify;";
mysql --host $DATABASE_NAME.$DB_IDENTIFIER.$REGION.rds.amazonaws.com --port 3306 \
      -u master -p$MASTER_PASSWORD specify < ./seed-databases/specify.sql;
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
ssh-keygen -t ed25519 -C "your_email@address.com";
#ssh-keygen -t rsa -b 4096 -C "your_email@address.com";

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
