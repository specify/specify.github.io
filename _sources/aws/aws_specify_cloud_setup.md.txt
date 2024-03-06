# Specify Cloud Setup

## Setup Aurora MySQL Database
TODO

## Setup EC2 Server
EC2 Parameters:
- ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-arm64-server-20220131  
ami-0770bf1d6ae61c858 

## Initial Commands

Initial commands are in the script 
[specify_cloud_setup.sh](https://github.com/specify/specify.github.io/blob/main/sphinx/scripts/specify_cloud_setup.sh)


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
                "ASSET_SERVER_URL": "https://<subdomain>.<domain_name>/web_asset_store.xml",
                "ANONYMOUS_USER": "<anon_user_name>"
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

Fill in everything between <>
defaults.env ->

```
DATABASE_HOST=<db_instance_name>.<identifier>.<region>.rds.amazonaws.com
DATABASE_PORT=<db_port>
MASTER_NAME=<master_username>
MASTER_PASSWORD=<master_password>
SECRET_KEY=<bogus>
ASSET_SERVER_URL=https://<asset_server_fqdn>/web_asset_store.xml
ASSET_SERVER_KEY=<asset_server_key>
REPORT_RUNNER_HOST=<xxx.xx.xx.xx>
REPORT_RUNNER_PORT=8080
CELERY_BROKER_URL=redis://redis/0
CELERY_RESULT_BACKEND=redis://redis/1
LOG_LEVEL=WARNING
SP7_DEBUG=false
```


## Info Misc.

### aws credentials:
- username: SPECIFY_USER
- password: SPECIFY_USER_PASSWORD
- access key: ACCESS_KEY
- secret access key: ACCESS_KEY_SECRET
- default region: REGION
- default output format: json

### AWS EC2 User data:

Make sure to fill in all variables (starting with `$`) in the following userdata script 
script before including it in an EC2 launch configuration.
[specify_cloud_ec2_userdata.sh](https://github.com/specify/specify.github.io/blob/main/sphinx/scripts/specify_cloud_ec2_userdata.sh)

* $BUCKET_NAME 
* $DATABASE_NAME
* $DB_IDENTIFIER
* $REGION
* $MASTER_PASSWORD


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


### Install Ubuntu EC2 instance with no docker

Make sure to fill in all variables (starting with `$`) in the following userdata script 
script before including it in an EC2 launch configuration.
[install_ec2_wo_docker.sh](https://github.com/specify/specify.github.io/blob/main/sphinx/scripts/install_ec2_wo_docker.sh)

* $BUCKET_NAME 


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
