# Useful bash commands

## sftp
```bash
sftp -i alec_specify_ssh_key ubuntu@ec2-52-206-2-67.compute-1.amazonaws.com;
pwd;
put /Users/alecwhite/git/specify-aws/report-fonts.jar ./;
ls;
exit;
```

background & foreground tasks
```bash

```

## check storage
```bash
df -H
du -sh *
```

## rsync
```bash
rsync -avz -e "ssh -i ~/specify/keys/specify-aws-ssh.pem" \
      ~/git/specify-aws/specify7-cluster/ \
      ubuntu@ec2-52-206-2-67.compute-1.amazonaws.com:/home/ubuntu/specify7-cluster/
```

## docker images view architecture and OS
```bash
for img in $(docker image ls -q); do echo $img; docker image inspect $img | jq '.[0] | {image: .RepoTags[0], os: .Os, arch: .Architecture}'; done
```

## run a django unit test through docker
```bash
sudo docker exec -it specify7-specify7-1 bash -c "ve/bin/python3 manage.py test specifyweb.notifications.tests.NotificationsTests"
```

## git stash specify files
```bash
git stash push -m "stash-name" file1.txt file2.txt
git stash list
git stash apply stash^(0)
```

## add user
```bash
adduser --disabled-password --gecos "" specify;
su - specify;
```

## docker build and push for multiple architectures
```bash
export DOCKER_CLI_EXPERIMENTAL=enabled
docker buildx create --name mybuilder --use # only do once
docker buildx inspect mybuilder --bootstrap

docker buildx build --platform linux/amd64,linux/arm64 -t specifyconsortium/specify-asset-service:connection_fix . --push

docker buildx use default # don't think needs to be done
```

## create linux user for ssh login and database access
```bash
#!/bin/bash

# Ask for the new username
read -p "Enter the new username: " username

# Create the new user without a password
sudo adduser --disabled-password --gecos "" $username

# Restrict the user with rbash
sudo usermod -s /bin/rbash $username

# Create a bin directory for the user for restricted commands
mkdir /home/$username/bin

# Symlink the MySQL client to the user's bin so they can use it
ln -s /usr/bin/mysql /home/$username/bin/mysql

# Restrict access to the user's home directory
sudo chown $username:$username /home/$username
sudo chmod 700 /home/$username

# Set up .ssh directory for SSH key-based authentication
mkdir /home/$username/.ssh
chmod 700 /home/$username/.ssh

# Ask for the user's public SSH key and add it to the authorized_keys file
read -p "Enter the new user's public SSH key: " ssh_key
echo "$ssh_key" > /home/$username/.ssh/authorized_keys
chmod 600 /home/$username/.ssh/authorized_keys
chown $username:$username /home/$username/.ssh/authorized_keys

mysql -u root -p
CREATE USER 'dbuser'@'localhost' IDENTIFIED BY 'DBUSER_PASSWORD';
GRANT SELECT, INSERT, UPDATE, DELETE ON your_database_name.* TO 'dbuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;

```

## view live formatted nginx logs example
```bash
docker logs specifycloud-nginx-1 --tail 1000 --since 10m --follow | \
grep -v updown | grep -v notification | grep specifycloud.org | \
awk '{ split($4,time,"["); print time[2], "-", $6, $7, $8, $9, $10, $11; }'
```

## Add swap memory
```bash
sudo fallocate -l 4G /swapfile;
# sudo dd if=/dev/zero of=/swapfile bs=1024 count=4096k; # if fallocate is not available
sudo chmod 600 /swapfile;
sudo mkswap /swapfile; # make swap file
sudo swapon /swapfile; # enable swap file
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab; # make change permanent

# check swap
sudo swapon --show;
free -h;

# swappiness defauls to 10, 100 is very argessive use, 0 is use only will absolutley necessary
cat /proc/sys/vm/swappiness;
sudo sysctl vm.swappiness=10;
sudo echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf; sudo sysctl -p; # make chane permanent

# increase swap size
sudo swapoff -v /swapfile # turn off
sudo fallocate -l 8G /swapfile; # resize
sudo mkswap /swapfile; sudo swapon /swapfile; # turn on
```