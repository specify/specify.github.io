These are the detailed instructions to get Specify7 up and running on an EC2 instance.  This is a temporary solution for deployment, with an ECS solution coming in the future.  These instruction require access to the `specify/docker-compositions` private repo.  For this kind of AWS deployment, it is easiest to use the `specifycloud` deployment, even with just one client instance.  I used the `specifycloud` deployment for my AWS EC2 instance, but if you want to include things like the asset server, you can create a separate instance of the asset server deployment (instructions here https://github.com/specify/web-asset-server).  You could also try to use the `all-in-one` deployment instead.

Specify7 was not originally designed to be cloud native, but since I have joined the team and picked up the project, I have been working on developing a modern cloud native solution.  I hope to soon have a set of CDK scripts that will make deployment to ECS, S3, and RDS simple and scalable.

## Spin Up EC2 Instance

- For the Amazon Machine Image (AMI), choose the default Ubuntu Server (Ubuntu Server 22.04 LTS) with the 64-bit x86 architecture.
- For the instance type, start with the t3.small or t3.medium.  Upgrade to a better instance if needed.
- In Network Settings, make sure to allow HTTP and HTTPS traffic.
- Setup your Key Pair for logging in.
- Launch Instance.

## S3 Setup

Create an S3 bucket for storing some static files.

You can either upload the GitHub repo to s3, or you can clone the repo directly in the EC2 instance.  If you are cloning inside the EC2 instance, note that you will need a GitHub access token to clone the private repo, instructions here https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token.  Make sure when configuring the token that you allow it to read from private repos, otherwise cloning will not work.

Upload your SQL file to the S3 bucket for the initial database upload.

There are two config files that you need to create for specifycloud:

spcloudservers.json ->
```json
{
	"servers": {
		"archireef": {
			"sp7": "edge",
			"sp6": "specify6803",
			"https": false,
			"database": "archireef"
		}
	},
	"decommissioned": [],
	"sp6versions": {
		"specify6803": "6.8.03"
	}
}
```
Your need to edit the version of Specify6 for your database's schema version (latest is 6.8.03).  For sp7, input the GitHub tag that you want to use in the repo (latest is always edge).  For your first run, keep https set to false.  Change it to true only after you have setup SSL/TLS.  The database value is the name of your database.

defaults.env ->
```
DATABASE_HOST=<YOUR_DATABASE_HOST>
DATABASE_PORT=3306
MASTER_NAME=master
MASTER_PASSWORD=<YOUR_MASTER_PASSWORD>
SECRET_KEY=temp
ASSET_SERVER_URL=https://assets1.specifycloud.org/web_asset_store.xml
ASSET_SERVER_KEY=<YOUR_ASSET_SERVER_KEY>
REPORT_RUNNER_HOST=10.132.218.32
REPORT_RUNNER_PORT=8080
CELERY_BROKER_URL=redis://redis/0
CELERY_RESULT_BACKEND=redis://redis/1
LOG_LEVEL=WARNING
SP7_DEBUG=false
```
You will only need to edit the DATABASE_HOST, MASTER_PASSWORD, ASSET_SERVER_URL, and ASSET_SERVER_KEY

## Configure Specify7

Once the EC2 instance is up and running, ssh into the EC2 instance.
- Download your AWS access key
- `chmod 600 YOUR-AWS-ACCESS-KEY.pem`
- On the EC2 Instance webpage, click connect, choose ssh, and copy the ssh command.  Make sure you are in the directory with the access key.
- You can try using AWS CloudShell if you don't want to ssh from your local machine.

Here are the commands to run to setup Specify7.  Note that for the AWS access key, you can use the AWS Secrets manager if you prefer.  Also note that after some of these commands, SystemD services will restart.  When that  happens, just press enter once or twice to you get back to the shell.

```bash
# Avoid services restarting during apt updates
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf;

# Run apt installs
sudo apt update;
sudo apt upgrade -y;
sudo apt install -y apt-transport-https ca-certificates git gh curl software-properties-common wget python3-pip awscli mysql-client j2cli;

# Configure AWS
aws configure set aws_access_key_id "YOUR_AWS_ACCESS_KEY_ID";
aws configure set aws_secret_access_key "YOUR_AWS_ACCESS_KEY_SECRET";
aws configure set default.region us-east-1;
aws configure set default.output json;

# Install Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg;
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
sudo apt update;
apt-cache policy docker-ce;
sudo apt install -y docker-ce;
docker --version; # Check to make sure it installed correctly

# Install docker compose
mkdir .docker;
mkdir .docker/cli-plugins;
curl -L "https://github.com/docker/compose/releases/download/v2.17.2/docker-compose-linux-$(uname -m)" -o ~/.docker/cli-plugins/docker-compose;
chmod +x ~/.docker/cli-plugins/docker-compose;
docker compose version; # Check to make sure it installed correctly

# Copy files from S3, only need to copy the file that you need
aws s3 cp s3://specify-cloud/repo-snapshots/docker-compositions/ ./ --recursive;
aws s3 cp s3://specify-cloud/config/github-access-key.txt ./;
aws s3 cp s3://specify-cloud/config/spcloudservers.json ./specifycloud/;
aws s3 cp s3://specify-cloud/config/defaults.env ./specifycloud/;

# Optional, need to clone if you did not copy repo from S3
# Clone private repo, need to use github cli
gh auth login --with-token < github-access-key.txt;
gh auth setup-git;
gh repo clone https://github.com/specify/docker-compositions.git;
```

## Spin Up RDS Instance

- For choosing the RDS engine type, I have been experimenting with using Aurora MySQL 5.7 to handle dynamic scaling, but the default option for Specify7 on AWS RDS is MariaDB 10.6.10.
- For Templates, I would suggest starting with Dev/Test instead of production.
- Setup Master password.
- For testing, I would suggest using either the `db.t3.medium` or `db.t3.large` instances. You might feel the need to upgrade to the `db.m5.large` instance or something similar.
- Decide on storage size to accommodate your data size. The general purpose SSD storage option should suffice, but you can try the provisioned IOPS SSD option if needed.
- Important, make sure in the connectivity options, select "Connect to an EC2 compute resource" and add your EC2 instance.
- Create database.

## Upload Data

Get the database host from the AWS RDS webpage.  In the connectivity tab of your RDS instance, copy the test marked 'Endpoint'.  Then run the following commands to upload your data to the database.

```bash
# Database setup
cd specifycloud;
mkdir seed-databases;
aws s3 cp s3://specify-cloud/seed-database/archireef.sql ./seed-databases/;
mysql --host specify-cloud-swiss-demo-database-1.c9qlnkmf2lfl.eu-central-2.rds.amazonaws.com --port 3306 -u master -p -e "create database archireef;";
mysql --host specify-cloud-swiss-demo-database-1.c9qlnkmf2lfl.eu-central-2.rds.amazonaws.com --port 3306 -u master -p specify < ./seed-databases/archireef.sql;
rm -f ./seed-databases/archireef.sql;
```

## Deploy Specify7

Here are the remaining commands on the EC2 instance to setup the database connection and start running Specify7.  Replace the S3 and RDS  urls with your own.

```bash
# Run Specify Network
cd specifycloud;
make;
sudo docker compose up -d;
```

Go to the AWS console webpage and navigate to the EC2 instance page.  For your instance, select the networking tab, then copy the the public IPv4 DNS address and open if in you r browser.  Note to change the url from https to http if you haven't setup SSL/TLS yet (https notes in the Concluding notes section). 

## Docker Container Dependencies

Containers:
- specify7
	- django application of specify7
	- depends on connections to the webpack, specify7-worker, redis, asset-server, nginx, and report-runner containers
	- depends on files being created by the specify6 container
- webpack
	- holds static files for the front-end
	- the nginx server depends on this container
	- independent container
- specify7-worker
	- python celery worker that runs long running tasks for specify7
	- depends on connection to specify7 container
- redis
	- acts as the job queue broker between the specify7 and specify7-worker containers
	- could possible be replaced by AWS SQS in the future
	- depends on connections to both the specify7 and specify7-worker containers
- asset-server
	- serves the assets to the specify7 container
	- independent container
- specify6
	- generates files and database schema version for specify7
	- the conainter stops after the files are created
	- independent container
	- this container can be removed if the static files are moved to S3 and then copied into the specify7 container on startup
- nginx
	- webserver for specify7 django application
	- depends on connection to specify7 and webpack containers
	- could possibly be replaced with AWS CloudFront
- report-runner
	- java application the generates reports for specify7
	- independent container

## Concluding Notes

You can use 'AWS Certificate Manager' or the tool 'CertBot' for setting up HTTPS SSL/TLS certificates.  Who will need to setup a domain name through AWS Route 53.  You will probably want to setup an elastic ip address for the EC2 instance through AWS as well.
Here are the instructions for using certbot:
```bash
sudo apt install -y certbot python3-certbot-apache;
sudo mkdir /var/www/archireef;
sudo certbot --webroot -w /var/www/archireef -d <YOUR_EC2_DOMAIN_NAME> certonly;
certbot certificates;
vim spcloudservers.json # change line to `https: true`
make;
sudo docker compose up -d;
sudo docker exec -it specifycloud_nginx_1 nginx -s reload; # Maybe needed
```

You might want to extend the time of your ssh connection:
SSH Client: vim ~/.ssh/config
```
Host *
    ServerAliveInterval 20
    #TCPKeepAlive no
```
SSH Server: sudo vim /etc/ssh/sshd_config
```
ClientAliveInterval 1200
ClientAliveCountMax 3
```
Then run `sudo systemctl reload sshd`

