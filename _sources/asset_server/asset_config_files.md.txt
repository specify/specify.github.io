# Specify 7 Docker Config Example

## Example defaults.env

```
DATABASE_HOST=10.133.58.98
DATABASE_PORT=3306
MASTER_NAME=master
MASTER_PASSWORD=master_password
SECRET_KEY=secret_key
ASSET_SERVER_URL=https://assets1.specifycloud.org/web_asset_store.xml
ASSET_SERVER_KEY=asset_server_key
REPORT_RUNNER_HOST=10.133.58.98
REPORT_RUNNER_PORT=8080
CELERY_BROKER_URL=redis://redis/0
CELERY_RESULT_BACKEND=redis://redis/1
LOG_LEVEL=WARNING
SP7_DEBUG=false
```

## Example docker-compose.yml

```yml
version: '3.7'

services:

  <client_name>:
    image: specifyconsortium/specify7-service:issue_388
    command: ["ve/bin/gunicorn", "-w", "1", "--threads", "5", "-b", "0.0.0.0:8000", "-t", "300", "specifyweb_wsgi"]
    init: true
    restart: unless-stopped
    volumes:
      - "specify6803:/opt/Specify:ro"
      - "static-files-<client_name>:/volumes/static-files"

      - "./settings/<client_name>-settings.py:/opt/specify7/settings/local_specify_settings.py:ro"

    env_file: defaults.env
    environment:
      - DATABASE_NAME=sandbox_rbge
      - ASSET_SERVER_COLLECTION=sandbox_rbge


  <client_name>-worker:
    image: specifyconsortium/specify7-service:issue_388
    command: ve/bin/celery -A specifyweb worker -l INFO --concurrency=1 -Q sandbox_rbge
    init: true
    restart: unless-stopped
    volumes:
      - "specify6803:/opt/Specify:ro"
      - "static-files-<client_name>:/volumes/static-files"
    env_file: defaults.env
    environment:
      - DATABASE_NAME=sandbox_rbge
      - ASSET_SERVER_COLLECTION=sandbox_rbge


  specify6800:
    image: specifyconsortium/specify6-service:6.8.00
    volumes:
      - "specify6800:/volumes/Specify"

  specify6801:
    image: specifyconsortium/specify6-service:6.8.01
    volumes:
      - "specify6801:/volumes/Specify"

  specify6803:
    image: specifyconsortium/specify6-service:6.8.03
    volumes:
      - "specify6803:/volumes/Specify"


  nginx:
    image: nginx
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
    volumes:

      - "static-files-sp7demofish-eu:/volumes/static-files-sp7demofish-eu:ro"

      - "static-files-rjb-madrid:/volumes/static-files-rjb-madrid:ro"

      - "static-files-mcnb:/volumes/static-files-mcnb:ro"

      - "static-files-herb-rbge:/volumes/static-files-herb-rbge:ro"

      - "static-files-<client_name>:/volumes/static-files-<client_name>:ro"

      - "static-files-cryoarks-test:/volumes/static-files-cryoarks-test:ro"

      - "static-files-eurl:/volumes/static-files-eurl:ro"



      - "specify6800:/volumes/specify6800:ro"

      - "specify6801:/volumes/specify6801:ro"

      - "specify6803:/volumes/specify6803:ro"


      - "./nginx.conf:/etc/nginx/conf.d/default.conf:ro"
      - "/etc/letsencrypt:/etc/letsencrypt:ro"
      - "/etc/ssl/certs/dhparam.pem:/etc/ssl/certs/dhparam.pem:ro"
      - "/var/www:/var/www:ro"

  redis:
    restart: unless-stopped
    image: redis:6.0

volumes:

  specify6800:

  specify6801:

  specify6803:



  static-files-<client_name>:

```

## Example nginx.conf

```
server {
    listen 80;
    server_name sp7demofish-eu.*;

    # The LetsEncrypt pass-though.
    location /.well-known/ {
             root /var/www/sp7demofish-eu/;
    }


    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    # This stanza defines the HTTPS end point.
    listen 443 ssl;
    server_name sp7demofish-eu.*;

    ssl_certificate /etc/letsencrypt/live/sp7demofish-eu.specifycloud.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/sp7demofish-eu.specifycloud.org/privkey.pem;

    # from https://cipherli.st/
    # and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_ecdh_curve secp384r1;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    # Disable preloading HSTS for now.  You can use the commented out header line that includes
    # the "preload" directive if you understand the implications.
    #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
    add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;

    ssl_dhparam /etc/ssl/certs/dhparam.pem;

    # The LetsEncrypt pass-though. I'm not sure if this is needed
    # on HTTPS side, but I'm including it just in case.
    location /.well-known/ {
             root /var/www/sp7demofish-eu/;
    }


    root /usr/share/nginx;

server {
    listen 80;
    server_name <client_name>.*;

    # The LetsEncrypt pass-though.
    location /.well-known/ {
             root /var/www/<client_name>/;
    }


    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    # This stanza defines the HTTPS end point.
    listen 443 ssl;
    server_name <client_name>.*;

    ssl_certificate /etc/letsencrypt/live/<client_name>.specifycloud.org/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/<client_name>.specifycloud.org/privkey.pem;

    # from https://cipherli.st/
    # and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
    ssl_ecdh_curve secp384r1;
    ssl_session_cache shared:SSL:10m;
    ssl_session_tickets off;
    ssl_stapling on;
    ssl_stapling_verify on;
    resolver 8.8.8.8 8.8.4.4 valid=300s;
    resolver_timeout 5s;
    # Disable preloading HSTS for now.  You can use the commented out header line that includes
    # the "preload" directive if you understand the implications.
    #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
    add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;

    ssl_dhparam /etc/ssl/certs/dhparam.pem;

    # The LetsEncrypt pass-though. I'm not sure if this is needed
    # on HTTPS side, but I'm including it just in case.
    location /.well-known/ {
             root /var/www/<client_name>/;
    }


    root /usr/share/nginx;

    location /static/ {
        root /volumes;
        rewrite ^/static/config/(.*)$ /specify6803/config/$1 break;
        rewrite ^/static/depository/(.*)$ /static-files-<client_name>/depository/$1 break;
        rewrite ^/static/(.*)$ /static-files-<client_name>/frontend-static/$1 break;
    }

    location / {
        resolver 127.0.0.11 valid=30s;
        set $backend "http://<client_name>:8000";
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

## Asset Server

Using the GitHub repo at https://github.com/specify/web-asset-server

### Example settings.py file

```
# Sample Specify web asset server settings.

# Turns on bottle.py debugging, module reloading and printing some
# information to console.
DEBUG = False

# This secret key is used to generate authentication tokens for requests.
# The same key must be set in the Web Store Attachment Preferences in Specify.
# A good source for key value is: https://www.grc.com/passwords.htm
# Set KEY to None to disable security. This is NOT recommended since doing so
# will allow anyone on the internet to use the attachment server to store
# arbitrary files.
KEY = '<asset_key>}'

# Auth token timestamp must be within this many seconds of server time
# in order to be considered valid. This prevents replay attacks.
# Set to None to disable time validation.
TIME_TOLERANCE = 600

# Set this to True to require authentication for downloads in addition
# to uploads and deletes.  Static file access, if enabled, is not
# affected by this setting.
REQUIRE_KEY_FOR_GET = False

# This is required for use with the Web Portal.
# Enables the 'getfileref' and '/static/...' URLs.
ALLOW_STATIC_FILE_ACCESS = True

# These values are interpolated into the web_asset_store.xml resource
# so the client knows how to talk to the server.
HOST = '<assets-name>.specifycloud.org'
PORT = 8080

SERVER_NAME = HOST
SERVER_PORT = PORT

# Port the development test server should listen on.
DEVELOPMENT_PORT = PORT

# Map collection names to directories.  Set to None to store
# everything in the same originals and thumbnail directories.  This is
# recommended unless some provision is made to allow attachments for
# items scoped above collections to be found.

COLLECTION_DIRS = {
    # 'COLLECTION_NAME': 'DIRECTORY_NAME',
}

# COLLECTION_DIRS = None

# Base directory for all attachments.
BASE_DIR = '/home/specify/attachments'

# Originals and thumbnails are stored in separate directories.
THUMB_DIR = 'thumbnails'
ORIG_DIR = 'originals'

# Set of mime types that the server will try to thumbnail.
CAN_THUMBNAIL = {'image/jpeg', 'image/gif', 'image/png', 'image/tiff', 'application/pdf'}

# What HTTP server to use for stand-alone operation.
SERVER = 'paste' # Requires python-paste package. Fast, and seems to work good.
#SERVER = 'wsgiref'  # For testing. Requires no extra packages.
```

### Possible Dockerfile for ECS Build (Unfinished)

```dockerfile
FROM arm64v8/ubuntu:18.04 AS run-asset-server

RUN apt-get update && apt-get -y install --no-install-recommends \
        ghostscript \
        imagemagick \
        python3.8 \
        python3.8-dev \
        python3.8-pip \
        python3-venv \
        git \
        nginx \
        certbot \
        awscli \
        s3fs \
        && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN groupadd -g 999 specify && \
        useradd -r -u 999 -g specify specify

RUN mkdir -p /home/specify && chown specify.specify /home/specify

USER specify
WORKDIR /home/specify

COPY --chown=specify:specify requirements.txt .

RUN python3.8 -m venv ve && ve/bin/pip install --no-cache-dir -r requirements.txt

COPY --chown=specify:specify *.py views ./

RUN mkdir -p /home/specify/attachments/

RUN echo \
        "import os" \
        "\nSERVER = 'paste'" \
        "\nSERVER_NAME = os.environ['SERVER_NAME']" \
        "\nSERVER_PORT = int(os.getenv('SERVER_PORT', 8080))" \
        "\nKEY = os.environ['ATTACHMENT_KEY']" \
        "\nDEBUG = os.getenv('DEBUG_MODE', 'false').lower() == 'true'" \
        >> settings.py

# Configure AWS
RUN aws configure set aws_access_key_id "aws_access_key_id" && \
aws configure set aws_secret_access_key "aws_secret_access_key" && \
aws configure set default.region us-east-1 && \
aws configure set default.output json

# S3 Mounting
RUN s3fs specify-cloud /home/specify/attachments/

EXPOSE 8080
CMD ve/bin/python server.py
```

### Asset nginx web-server config

```
server {
       # HTTP access is needed for Specify 6. It will not work with HTTPS.
       listen 80 default_server;
       server_name assets1.specifycloud.org;
       client_max_body_size 0;

       # The LetsEncrypt certificate mechanism places a nonce
       # challenge at this location to prove we have control of the
       # domain. Mapping it to a location in the filesystem allows us
       # to easily use their auto renew system.
       location /.well-known/ {
                root /var/www/;
       }

       # The web_asset_store.xml resource must be proxied to the
       # actual server so that it gets the correct timestamp headers.
       # We do a string substitution on the response to make the links
       # it defines point to this proxy.
       location = /web_asset_store.xml {
                proxy_pass http://localhost:8080/web_asset_store.xml;
                sub_filter 'http://assets1.specifycloud.org:8080' 'http://assets1.specifycloud.org';
                sub_filter_once off;
                sub_filter_types text/xml;
       }

       # All other requests are passed to the actual asset server
       # unchanged.
       location / {
                proxy_pass http://localhost:8080/;
       }
}

server {
       # This stanza defines the HTTPS end point.
       listen 443 ssl default_server;
       server_name assets1.specifycloud.org;
       client_max_body_size 0;

       ssl_certificate /etc/letsencrypt/live/assets1.specifycloud.org/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/assets1.specifycloud.org/privkey.pem;

       # from https://cipherli.st/
       # and https://raymii.org/s/tutorials/Strong_SSL_Security_On_nginx.html

       ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
       ssl_prefer_server_ciphers on;
       ssl_ciphers "EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH";
       ssl_ecdh_curve secp384r1;
       ssl_session_cache shared:SSL:10m;
       ssl_session_tickets off;
       ssl_stapling on;
       ssl_stapling_verify on;
       resolver 8.8.8.8 8.8.4.4 valid=300s;
       resolver_timeout 5s;
       # Disable preloading HSTS for now.  You can use the commented out header line that includes
       # the "preload" directive if you understand the implications.
       #add_header Strict-Transport-Security "max-age=63072000; includeSubdomains; preload";
       add_header Strict-Transport-Security "max-age=63072000; includeSubdomains";
       add_header X-Frame-Options DENY;
       add_header X-Content-Type-Options nosniff;

       ssl_dhparam /etc/ssl/certs/dhparam.pem;

       # The LetsEncrypt pass-though. I'm not sure if this is needed
       # on HTTPS side, but I'm including it just in case.
       location /.well-known/ {
                root /var/www/;
       }

       # This is the same as the above, except the links get rewritten
       # to use HTTPS in addition to changing the port.
       location = /web_asset_store.xml {
                proxy_pass http://localhost:8080/web_asset_store.xml;
                sub_filter 'http://assets1.specifycloud.org:8080' 'https://assets1.specifycloud.org';
                sub_filter_once off;
                sub_filter_types text/xml;
       }

       # Everything else is just passed through.
       location / {
                proxy_pass http://localhost:8080/;
       }
}
```