## EC2 Non-Dockerized Build

[asset_server_setup.sh](../scripts/asset_server_setup.sh) to initialize the asset server.

/etc/systemd/system/web-asset-server.service ->
```
[Unit]
Description=Specify Web Asset Server
Wants=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/web-asset-server
ExecStart=/usr/bin/ubuntu/web-asset-server/ve/usr/bin/python /home/ubuntu/web-asset-server/server.py
Restart=always

[Install]
WantedBy=multi-user.target
```

settings.py ->
```python
# Sample Specify web asset server settings.

# Turns on bottle.py debugging, module reloading and printing some
# information to console.
DEBUG = True

# This secret key is used to generate authentication tokens for requests.
# The same key must be set in the Web Store Attachment Preferences in Specify.
# A good source for key value is: https://www.grc.com/passwords.htm
# Set KEY to None to disable security. This is NOT recommended since doing so
# will allow anyone on the internet to use the attachment server to store
# arbitrary files.
KEY = 'test_attachment_key'

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
#HOST = 'localhost'
HOST = 'assets-test.specifycloud.org'
PORT = 8080
#PORT = 80

SERVER_NAME = HOST
SERVER_PORT = PORT

# Port the development test server should listen on.
DEVELOPMENT_PORT = PORT

# Map collection names to directories.  Set to None to store
# everything in the same originals and thumbnail directories.  This is
# recommended unless some provision is made to allow attachments for
# items scoped above collections to be found.

# COLLECTION_DIRS = {
#     # 'COLLECTION_NAME': 'DIRECTORY_NAME',
#     'KUFishvoucher': 'Ichthyology',
#     'KUFishtissue': 'Ichthyology',
# }

COLLECTION_DIRS = {
    'herb_rbge': 'herb_rbge',
    'KUFishvoucher': 'sp7demofish',
    'KUFishtissue': 'sp7demofish',
}

# Base directory for all attachments.
#BASE_DIR = '/home/specify/attachments/'
BASE_DIR = '/home/ubuntu/attachments/'

# Originals and thumbnails are stored in separate directories.
THUMB_DIR = 'thumbnails'
ORIG_DIR = 'originals'

# Set of mime types that the server will try to thumbnail.
CAN_THUMBNAIL = {'image/jpeg', 'image/gif', 'image/png', 'image/tiff', 'application/pdf'}

# What HTTP server to use for stand-alone operation.
# SERVER = 'paste' # Requires python-paste package. Fast, and seems to work good.
SERVER = 'wsgiref'  # For testing. Requires no extra packages.
```

/etc/nginx/sites-enabled/assets.conf from the aasets1.specifycloud.org- ->
```
# Nginx configuration for supplying an HTTPS end point for the web
# asset server. The asset server is running on the same system
# (demo-assets.specifycloud.org) on port 8080 meaning it can run
# without root privileges and without using authbind. Nginx proxies
# HTTP requests on port 80 and HTTPS requests on port 443 to the
# underlying asset server. It also rewrites the web_asset_store.xml
# response to cause subsequent request to go through the proxy.

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

/etc/letsencrypt/renewal/assets1.specifycloud.org.conf ->
```
# renew_before_expiry = 30 days
cert = /etc/letsencrypt/live/assets1.specifycloud.org/cert.pem
privkey = /etc/letsencrypt/live/assets1.specifycloud.org/privkey.pem
chain = /etc/letsencrypt/live/assets1.specifycloud.org/chain.pem
fullchain = /etc/letsencrypt/live/assets1.specifycloud.org/fullchain.pem
version = 1.9.0
archive_dir = /etc/letsencrypt/archive/assets1.specifycloud.org

# Options and defaults used in the renewal process
[renewalparams]
authenticator = webroot
account = a563615cc912ed3d7a3edfede09d6760
post_hook = systemctl reload nginx
server = https://acme-v02.api.letsencrypt.org/directory
[[webroot_map]]
assets1.specifycloud.org = /var/www
```

/etc/ssl/certs/dhparam.pem from assets1.specofycloud.org->
```
-----BEGIN DH PARAMETERS-----
MIIBCAKCAQEAlcFKsIuFylwX47jxqbNT0wSVD6ifznsMcti8f7T+zaQQNr84IYIM
pNTT9E6SrVkkJg2u1nGScNqj5lArXvrda6zL66T8WmkFFrGfNW7RYCQ3vpg6BpGs
dJ3+HtWYDNoMbeCrDyMz1DDfX/3OWblTTZRbjpvn/tEgTAn3DexP/QkE9E2c1AUX
Mf/07vWpZ7giemaNgaME3fHDKyReNhTpfg1eDKypUUhEmr+PJmWQ9LQBc12LyXOP
DaFwAJUrqwEqrQP5fEQdOMdh522RwuD2/fPeXTukQHI8gUuMjk652aeLOcn1Ufhy
/KbbV6TJi7wS5F3HVaNXGOLMsHq+CywOCwIBAg==
-----END DH PARAMETERS-----
```