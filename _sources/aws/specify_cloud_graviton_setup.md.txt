# Specify Cloud Graviton Setup

Commands for running on ubuntu 20.04 arm64
See `~/git/specify-aws-specify7-mosti-in-one-lite/docker-entrypoint.sh` for latest
```bash
#!/bin/bash

sudo apt update;
sudo apt upgrade -y;
sudo add-apt-repository ppa:openjdk-r/ppa; # repo for jdk-8
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -;
sudo apt -y install --no-install-recommends \
  build-essential \
  git \
  libldap2-dev \
  libmariadbclient-dev \
  libsasl2-dev \
  nodejs \
  npm \
  python3-venv \
  python3.8 \
  python3.8-dev \
  redis \
  unzip \
  openjdk-8-jdk \
  maven \
  ant \
  awscli \
  mysql-client \
  nginx \
  certbot \
  python3-certbot-nginx;
node -v;
#sudo apt install -y j2cli;
sudo apt install -y nginx;
#sudo apt install -y apache2 libapache2-mod-wsgi-py3;
sudo apt install -y mysql-client-core-8.0;
sudo apt clean;

# Configure AWS
aws configure set aws_access_key_id "ACCESS_KEY";
aws configure set aws_secret_access_key "ACCESS_KEY_SECRET";
aws configure set default.region us-east-1;
aws configure set default.output json;

# Specify6
wget https://update.specifysoftware.org/6803/Specify_unix_64.sh;
sh Specify_unix_64.sh -q -dir ./Specify6.8.03;
sudo ln -s $(pwd)/Specify6.8.03 /opt/Specify;

# Specify7
git clone https://github.com/specify/specify7.git;
mkdir ~/wb_upload_logs;
mkdir ~/specify_depository;
#cd specify7
#git checkout tags/v7.8.6

# Specify settings config
cd ~/specify7;
echo 'export DOMAIN_NAME=ec2-3-87-116-210.compute-1.amazonaws.com' >> ~/.bashrc;
echo 'export DATABASE_HOST=specify-cloud-aurora-v2-test-database-1-instance-1.cqvncffkwz9t.us-east-1.rds.amazonaws.com' >> ~/.bashrc;
echo 'export DATABASE_PORT=3306' >> ~/.bashrc;
echo 'export DATABASE_NAME=sp7demofish' >> ~/.bashrc;
echo 'export MASTER_NAME=master' >> ~/.bashrc;
echo 'export MASTER_PASSWORD=dance-taco-magic-rainbow-vibe' >> ~/.bashrc;
echo 'export WEB_ATTACHMENT_URL=https://assets1.specifycloud.org/web_asset_store.xml' >> ~/.bashrc;
echo 'export WEB_ATTACHMENT_KEY=tnhercbrhtktanehul.dukb' >> ~/.bashrc;
echo 'export WEB_ATTACHMENT_COLLECTION=sp7demofish' >> ~/.bashrc;
echo 'export REPORT_RUNNER_HOST=10.133.58.98' >> ~/.bashrc;
echo 'export REPORT_RUNNER_PORT=8080' >> ~/.bashrc;
source ~/.bashrc;
sed -i "s/DATABASE_HOST = 'SpecifyDB'/DATABASE_HOST = '${DATABASE_HOST}'/g" specifyweb/settings/specify_settings.py;
sed -i "s/DATABASE_PORT = ''/DATABASE_PORT = '${DATABASE_PORT}'/g" specifyweb/settings/specify_settings.py;
sed -i "s/DATABASE_NAME = 'SpecifyDB'/DATABASE_NAME = '$DATABASE_NAME'/g" specifyweb/settings/specify_settings.py;
sed -i "s/MASTER_NAME = 'MasterUser'/MASTER_NAME = '$MASTER_NAME'/g" specifyweb/settings/specify_settings.py;
sed -i "s/MASTER_PASSWORD = 'MasterPassword'/MASTER_PASSWORD = '$MASTER_PASSWORD'/g" specifyweb/settings/specify_settings.py;
sed -i "s|WEB_ATTACHMENT_URL = None|WEB_ATTACHMENT_URL = '$WEB_ATTACHMENT_URL'|g" specifyweb/settings/specify_settings.py;
sed -i "s/WEB_ATTACHMENT_KEY = None/WEB_ATTACHMENT_KEY = '$WEB_ATTACHMENT_KEY'/g" specifyweb/settings/specify_settings.py;
sed -i "s/WEB_ATTACHMENT_COLLECTION = None/WEB_ATTACHMENT_COLLECTION = '$WEB_ATTACHMENT_COLLECTION'/g" specifyweb/settings/specify_settings.py;
sed -i "s/REPORT_RUNNER_HOST = ''/REPORT_RUNNER_HOST = '$REPORT_RUNNER_HOST'/g" specifyweb/settings/specify_settings.py;
sed -i "s/REPORT_RUNNER_PORT = ''/REPORT_RUNNER_PORT = '$REPORT_RUNNER_PORT'/g" specifyweb/settings/specify_settings.py;
sed -i "s/home\/specify/home\/ubuntu/g" specifyweb/settings/specify_settings.py;

# Setup Specify7 python environment
cd ~/specify7;
python3.8 -m venv ./ve;
./ve/bin/pip install wheel;
./ve/bin/pip install --upgrade -r ./requirements.txt;
ve/bin/pip install --no-cache-dir gunicorn;

# Database setup
aws s3 cp s3://specify-cloud/seed-database/sp7demofish.sql ~/specify7/seed-database/;
mysql --host $DATABASE_HOST -u $MASTER_NAME -p"${MASTER_PASSWORD}" -e "create database ${DATABASE_NAME};";
mysql --host $DATABASE_HOST -u $MASTER_NAME -p"${MASTER_PASSWORD}" $DATABASE_NAME < ~/specify7/seed-database/sp7demofish.sql;

# Build Specify7
cd specify7;
source ve/bin/activate;
make;
#make runserver;
#ve/bin/pip install gunicorn
#ve/bin/gunicorn -w 3 -b 0.0.0.0.8000 -t 300 specifyweb_wsgi;
sudo ln -s $(pwd)/specify7 /opt/specify7;

# Specify7 worker
cd ~/specify7;
celery -A specifyweb worker -l INFO --concurrency=1 &;

# Webserver setup
mkdir ~/media;
sed -i "s/MEDIA_ROOT = ''/MEDIA_ROOT = '\/home\/ubuntu\/media'/g" ~/specify7/specifyweb/settings/__init__.py;
sed -i "s/MEDIA_URL = ''/MEDIA_URL = 'http:\/\/${DOMAIN_NAME}\/media'/g" ~/specify7/specifyweb/settings/__init__.py;

# Nginx webserver
#sudo ufw allow 'Nginx HTTP';
#sudo ufw status;
sed -i "s/server_name localhost/server_name sp7demofish/g" ~/specify7/nginx.conf;
sudo cp ~/specify7/nginx.conf /etc/nginx/sites-available/specify7;
sudo ln -s /etc/nginx/sites-available/specify7 /etc/nginx/sites-enabled/;
sudo nginx -c ~/specify7/nginx.conf;

# Apache webserver
sed "s/\$servername/$DOMAIN_NAME/g" ~/specify7/specifyweb_apache.conf;
sudo rm /etc/apache2/sites-enabled/000-default.conf;
sudo ln -s $(pwd)/specify7/specifyweb_apache.conf /etc/apache2/sites-enabled/;
sudo systemctl restart apache2.service;
#sudo invoke-rc.d apache2 restart;

# TLS/SSL
sudo certbot --nginx -d your_domain;
sudo ufw allow 'Nginx Full';
sudo ufw delete allow 'Nginx HTTP';
```

bash script for setting env varibales and specify7 setting configs:
```bash
#!/bin/bash

sed -i "s/DATABASE_NAME = 'SpecifyDB'/DATABASE_NAME = ''/g" specifyweb/settings/specify_settings.py;

update_setting() {
    local setting_key="$1"
    local setting_value="$2"
    local file_path="specifyweb/settings/specify_settings.py"

    sed -i "s/${setting_key} = ''/${setting_key} = '${setting_value}'/g" "$file_path"
}

cat <<EOT >> ~/.bashrc
export DATABASE_HOST=specify-cloud-aurora-test-database-1-instance-1.cqvncffkwz9t.us-east-1.rds.amazonaws.com
export DATABASE_PORT=3306
export DATABASE_NAME=sp7demofish
export MASTER_NAME=master
export MASTER_PASSWORD=mastermaster
export WEB_ATTACHMENT_URL=https://assets1.specifycloud.org/web_asset_store.xml
export WEB_ATTACHMENT_KEY=tnhercbrhtktanehul.dukb
export WEB_ATTACHMENT_COLLECTION=sp7demofish
export REPORT_RUNNER_HOST=10.133.58.98
export REPORT_RUNNER_PORT=8080
EOT

source ~/.bashrc;

update_setting "DATABASE_HOST" "$DATABASE_HOST"
update_setting "DATABASE_PORT" "$DATABASE_PORT"
update_setting "DATABASE_NAME" "$DATABASE_NAME"
update_setting "MASTER_NAME" "$MASTER_NAME"
update_setting "MASTER_PASSWORD" "$MASTER_PASSWORD"
update_setting "WEB_ATTACHMENT_URL" "$WEB_ATTACHMENT_URL"
update_setting "WEB_ATTACHMENT_KEY" "$WEB_ATTACHMENT_KEY"
update_setting "WEB_ATTACHMENT_COLLECTION" "$WEB_ATTACHMENT_COLLECTION"
update_setting "REPORT_RUNNER_HOST" "$REPORT_RUNNER_HOST"
update_setting "REPORT_RUNNER_PORT" "$REPORT_RUNNER_PORT"

```

nginx.conf ->
```
server {
    listen 80;
    server_name ec2-54-162-114-41.compute-1.amazonaws.com;
    root /usr/share/nginx;
    client_max_body_size 128M;

    # serve static files directly
    location /static/ {
        #client_max_body_size 0;
        root /volumes;
        #rewrite ^/static/config/(.*)$ /specify6/config/$1 break;
        #rewrite ^/static/depository/(.*)$ /static-files/depository/$1 break;
        #rewrite ^/static/js/(.*)$ /webpack-output/$1 break;
        #rewrite ^/static/(.*)$ /static-files/frontend-static/$1 break;
        rewrite ^/static/config/(.*)$ /home/ubuntu/specify6.8.03/config/$1 break;
        rewrite ^/static/depository/(.*)$ /home/ubuntu/static-files/depository/$1 break;
        #rewrite ^/static/js/(.*)$ /webpack-output/$1 break;
        rewrite ^/static/(.*)$ /static-files/frontend-static/$1 break;
    }

    # proxy these urls to the asset server
    location ~ ^/(fileget|fileupload|filedelete|getmetadata|testkey|web_asset_store.xml) {
        client_max_body_size 0;
        resolver 127.0.0.11 valid=30s;
        set $backend "http://asset-server:8080";
        proxy_pass $backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # proxy everything else to specify 7
    location / {
        client_max_body_size 400M;
        client_body_buffer_size 400M;
        client_body_timeout 120;
        resolver 127.0.0.11 valid=30s;
        set $backend "http://specify7:8000";
        proxy_pass $backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

simple nginx.conf ->
```
server {
    listen 80;
    server_name ec2-54-162-114-41.compute-1.amazonaws.com;
    location / {
        # django running in uWSGI
        uwsgi_pass unix:///run/uwsgi/app/django/socket;
        include uwsgi_params;
        uwsgi_read_timeout 300s;
        client_max_body_size 32m;
    }
    location /static/ {
       # static files
       alias /home/ubuntu/static/; # ending slash is required
    }
    location /media/ {
        # media files, uploaded by users
        alias /home/ubuntu/media/; # ending slash is required
    }
}

```

specifyweb_apache.conf ->
```
<VirtualHost *:80>
        # Grant access to the Specify directories.
        <Directory /home/ubuntu/specify_depository>
	        Options +FollowSymLinks -Indexes -MultiViews
            Require all granted
        </Directory>

        <Directory /home/ubuntu/web_upload_logs>
	        Options +FollowSymLinks -Indexes -MultiViews
            Require all granted
        </Directory>

        <Directory /opt/Specify/config>
	        Options +FollowSymLinks -Indexes -MultiViews
            Require all granted
        </Directory>

        <Directory /opt/specify7>
	        Options +FollowSymLinks -Indexes -MultiViews
            Require all granted
        </Directory>

        # Alias the following to the location set in specifyweb/settings/local_specify_settings.py
        Alias /static/depository /home/ubuntu/specify_depository

        # Alias the following to the Specify6 installation + /config
        Alias /static/config    /opt/Specify/config

        # Alias the following to the Specify7 installation + /specifyweb/frontend/static
        Alias /static           /opt/specify7/specifyweb/frontend/static

        # Set the user and group you want the Specify 7 python process to run as.
        # The python-home points to the location of the python libraries in the
        # virtualenv you established. If not using a virtualenv, leave off the
        # python-home parameter.
        WSGIDaemonProcess ec2-3-87-116-210.compute-1.amazonaws.com user=ubuntu group=ubuntu python-home=/opt/specify7/ve
        WSGIProcessGroup ec2-3-87-116-210.compute-1.amazonaws.com

        # Alias the following to the Specify7 installation + /specifyweb.wsgi
        WSGIScriptAlias / /opt/specify7/specifyweb.wsgi

        ErrorLog /var/log/apache2/error.log
        # # Possible values include: debug, info, notice, warn, error, crit,
        # # alert, emerg.
        # LogLevel warn

        CustomLog /var/log/apache2/access.log combined
</VirtualHost>
```

default apache
```
<VirtualHost *:80>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
</VirtualHost>
```

Webpack notes:
```bash
webpack 5.73.0 compiled with 2 warnings in 104175 ms
make[1]: Leaving directory '/home/ubuntu/specify7/specifyweb/frontend/js_src'
```

spcloud nginx config notes:
`rewrite ^/static/depository/(.*)$ /static-files-sp7demofish-eu/depository/$1 break;`
check out /static-files-sp7demofish-eu/depository/
example from spcloud nginx.conf using http ->
```
server {
    listen 80;
    server_name cryoarks-test.*;

    # The LetsEncrypt pass-though.
    location /.well-known/ {
             root /var/www/cryoarks-test/;
    }



    root /usr/share/nginx;

    location /static/ {
        root /volumes;
        rewrite ^/static/config/(.*)$ /specify6801/config/$1 break;
        rewrite ^/static/depository/(.*)$ /static-files-cryoarks-test/depository/$1 break;
        rewrite ^/static/(.*)$ /static-files-cryoarks-test/frontend-static/$1 break;
    }

    location / {
        resolver 127.0.0.11 valid=30s;
        set $backend "http://cryoarks-test:8000";
        proxy_pass $backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 600s;
        client_max_body_size 0;
    }
}
```
then edited for aws ec2 web server ->
```
server {
    listen 80;
    server_name ec2-54-162-114-41.compute-1.amazonaws.com;

    # The LetsEncrypt pass-though.
    #location /.well-known/ {
    #         root /var/www/cryoarks-test/;
    #}

    root /usr/share/nginx;

    location /static/ {
        root /volumes;
        rewrite ^/static/config/(.*)$ /specify6803/config/$1 break;
        rewrite ^/static/depository/(.*)$ /static-files-cryoarks-test/depository/$1 break;
        rewrite ^/static/(.*)$ /static-files-cryoarks-test/frontend-static/$1 break;
    }

    location / {
        resolver 127.0.0.11 valid=30s;
        set $backend "http://cryoarks-test:8000";
        proxy_pass $backend;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout 600s;
        client_max_body_size 0;
    }
}
```