# Asset Server Configuration

Here is an asset server configuration example with the latest image `specifyconsortium/specify-asset-service:connection_fix`.
I spun up a server with the following config and got it working `assets-docker.specifycloud.org/web_asset_store.xml`
Make sure to configure your dns record to the IP address of your server.

docker-compose.yml ->
```
version: '3.7'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"

    volumes:
      - "./nginx.conf:/etc/nginx/conf.d/default.conf:ro"

  asset-server:
    restart: unless-stopped
    image: specifyconsortium/specify-asset-service:connection_fix
    init: true
    volumes:
      # Store all attachments outside the container, in a separate volume
      # - "attachments:/home/specify/attachments"
      - "/home/ubuntu/attachments:/home/specify/attachments"
    environment:
      # Replace this with the URL at which asset server would be publicly available
      SERVER_NAME: assets-docker.specifycloud.org
      SERVER_PORT: 8080
      # SERVER: paste
      ATTACHMENT_KEY: qwertyasdfghzxcvbnlmnop
      DEBUG_MODE: false
      COLLECTION_DIRS: >
        {
          'sp7demofish':'sp7demofish',
          'KUFishvoucher':'KUFishvoucher',
          'KUFishtissue':'KUFishtissue'
        }
      BASE_DIR: /home/ubuntu/attachments

volumes:
  attachments: # the asset-servers attachment files
```

nginx.conf ->
```
server {
    listen 80 default_server;
    server_name assets-docker.specifycloud.org;
    client_max_body_size 0;

    location /.well-known/ {
        root /var/www/assets-docker/;
    }

    location = /web_asset_store.xml {
        proxy_pass http://asset-server:8080/web_asset_store.xml;
        sub_filter 'http://assets-docker.specifycloud.org:8080' 'http://assets-docker.specifycloud.org';
        sub_filter_once off;
        sub_filter_types text/xml;
    }

    location / {
        proxy_pass http://asset-server:8080/;
    }
}
```

Then to get the asset server working with https and connected with Specify7, I created certificates with certbot, and then used the follow config

certbot bash commands ->
```
# Make sure the nginx server is running
sudo mkdir /var/www;
sudo mkdir /var/www/assets-docker;
sudo certbot --webroot -w /var/www/assets-docker -d assets-docker.specifycloud.org certonly;
```

docker-compose.yml ->
```
version: '3.7'
services:
  nginx:
    image: nginx:alpine
    ports:
      - "80:80"
      - "443:443"

    volumes:
      - "./nginx.conf:/etc/nginx/conf.d/default.conf:ro"

  asset-server:
    restart: unless-stopped
    image: specifyconsortium/specify-asset-service:connection_fix
    init: true
    volumes:
      # Store all attachments outside the container, in a separate volume
      # - "attachments:/home/specify/attachments"
      - "/home/ubuntu/attachments:/home/specify/attachments"
    environment:
      # Replace this with the URL at which asset server would be publicly available
      SERVER_NAME: assets-docker.specifycloud.org
      SERVER_PORT: 8080
      # SERVER: paste
      ATTACHMENT_KEY: qwertyasdfghzxcvbnlmnop
      DEBUG_MODE: false
      HTTPS: true
      COLLECTION_DIRS: >
        {
          'sp7demofish':'sp7demofish',
          'KUFishvoucher':'KUFishvoucher',
          'KUFishtissue':'KUFishtissue'
        }
      BASE_DIR: /home/ubuntu/attachments

volumes:
  attachments: # the asset-servers attachment files
```

nginx.conf ->
```
server {
    listen 80 default_server;
    server_name assets-docker.specifycloud.org;
    client_max_body_size 0;

    location /.well-known/ {
        root /var/www/assets-docker/;
    }

    location = /web_asset_store.xml {
        proxy_pass http://asset-server:8080/web_asset_store.xml;
        sub_filter 'http://assets-docker.specifycloud.org:8080' 'http://assets-docker.specifycloud.org';
        sub_filter_once off;
        sub_filter_types text/xml;
    }

    location / {
        proxy_pass http://asset-server:8080/;
    }
}

server {
       # This stanza defines the HTTPS end point.
       listen 443 ssl default_server;
       server_name assets-docker.specifycloud.org;
       client_max_body_size 0;

       ssl_certificate /etc/letsencrypt/live/assets-docker.specifycloud.org/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/assets-docker.specifycloud.org/privkey.pem;

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
                root /var/www/assets-docker/;
       }

       # This is the same as the above, except the links get rewritten
       # to use HTTPS in addition to changing the port.
       location = /web_asset_store.xml {
                proxy_pass http://asset-server:8080/web_asset_store.xml;
                sub_filter 'http://assets-docker.specifycloud.org:8080' 'https://assets-docker.specifycloud.org';
                sub_filter_once off;
                sub_filter_types text/xml;
       }

       # Everything else is just passed through.
       location / {
                proxy_pass http://asset-server:8080/;
       }
}
```

Make sure to set `- ASSET_SERVER_URL=https://assets-docker.specifycloud.org/web_asset_store.xml` in your specify7 and specify7-worker docker containers

Let me know if the new image and config works for you!
