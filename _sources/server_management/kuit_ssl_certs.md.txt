## New certificate on biprdsp7wbdb.cc.ku.edu server

Form to request new certificate: https://kuit.service-now.com/nav_to.do?uri=%2Fcom.glideapp.servicecatalog_cat_item_view.do%3Fv%3D1%26sysparm_id%3D78fee42fdb2a8850162673e1ba96195b%26sysparm_link_parent%3D322911f41bec6490cf2d337e034bcb23%26sysparm_catalog%3De0d08b13c3330100c8b837659bba8fb4%26sysparm_catalog_view%3Dcatalog_default%26sysparm_view%3Dcatalog_default

generate CSR string:
```bash
openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr
```

with configuration:
```
Country Name (2 letter code) [XX]:US
State or Province Name (full name) []:Kansas
Locality Name (eg, city) [Default City]:Lawrence
Organization Name (eg, company) [Default Company Ltd]:University of Kansas
Organizational Unit Name (eg, section) []:Specify
Common Name (eg, your name or your server's hostname) []:biimages.biodiversity.ku.edu
Email Address []:alec.white@ku.edu
A challenge password []:
An optional company name []:
```

verify configuration with `openssl req -new -newkey rsa:2048 -nodes -keyout server.key -out server.csr` with output
```
C = US, ST = Kansas, L = Lawrence, O = University of Kansas, OU = Specify, CN = biimages.biodiversity.ku.edu, emailAddress = alec.white@ku.edu
```

after receiving new certificate files
```
biimages_biodiversity_ku_edu.cer
biimages_biodiversity_ku_edu_cert.cer
biimages.biodiversity.ku.edu.conf
biimages_biodiversity_ku_edu.crt
biimages_biodiversity_ku_edu_interm.cer
biimages_biodiversity_ku_edu.p7b
biimages_biodiversity_ku_edu.pem
```

generate 'fullchain.pem' file with concatenation
```bash
cat biimages_biodiversity_ku_edu.pem biimages_biodiversity_ku_edu_interm.cer > fullchain.pem
```

then run commands to copy files into proper locations (make sure the number is incremented ex. 40)
```bash
sudo cp server.key /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/privkey40.pem
sudo cp biimages_biodiversity_ku_edu.pem /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/cert40.pem;
sudo cp biimages_biodiversity_ku_edu_interm.cer /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/chain40.pem;
sudo cp fullchain.pem /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/fullchain40.pem;
```

then create symbolic links to where the nginx file looks for SSL files
```bash
sudo ln -sf /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/fullchain40.pem /etc/letsencrypt/live/biimages.biodiversity.ku.edu/fullchain.pem;
sudo ln -sf /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/privkey40.pem /etc/letsencrypt/live/biimages.biodiversity.ku.edu/privkey.pem;
sudo ln -sf /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/chain40.pem /etc/letsencrypt/live/biimages.biodiversity.ku.edu/chain.pem;
sudo ln -sf /etc/letsencrypt/archive/biimages.biodiversity.ku.edu/cert40.pem /etc/letsencrypt/live/biimages.biodiversity.ku.edu/cert.pem;
```

here are the line in the '/etc/nginx/conf.d/web-asset-server.conf' nginx file `sudo vim /etc/nginx/conf.d/web-asset-server.conf`
```
server_name biimages.biodiversity.ku.edu;
ssl_certificate /etc/letsencrypt/live/biimages.biodiversity.ku.edu/fullchain.pem;
ssl_certificate_key /etc/letsencrypt/live/biimages.biodiversity.ku.edu/privkey.pem;
```

verify the key and cert are correct by making sure their hashes are the same
```bash
sudo openssl x509 -noout -modulus -in /etc/letsencrypt/live/biimages.biodiversity.ku.edu/cert.pem | openssl md5
sudo openssl rsa -noout -modulus -in /etc/letsencrypt/live/biimages.biodiversity.ku.edu/privkey.pem | openssl md5
```

verify the expiration date of the cert:
```
sudo openssl x509 -in fullchain.pem -noout -dates;
```

restart nginx
```bash
sudo systemctl restart nginx.service
#sudo systemctl restart web-asset-server.service
sudo systemctl status web-asset-server.service
```

## web-portal certificate

here are the lines in the `/etc/nginx/conf.d/webportal-nginx.conf` nginx file
```
server_name collections.biodiversity.ku.edu;
ssl_certificate /home/specify/keystore/collections_biodiversity_ku_edu_cert.cer;
ssl_certificate_key /home/specify/keystore/collections_biodiversity_ku_edu.key;
```

```bash
cat collections_biodiversity_ku_edu.pem collections_biodiversity_ku_edu_interm.cer > fullchain.pem
```

```bash
sudo cp collections_biodiversity_ku_edu_cert.cer /home/specify/keystore/cert.pem
sudo cp ~/webportal-keys/webportal_server.key /home/specify/keystore/privkey.pem
sudo cp ~/webportal-keys/fullchain.pem /home/specify/keystore/fullchain.pem
```

```bash
sudo chown specify:bi-sp7access cert.pem;
sudo chown specify:bi-sp7access privkey.pem;
sudo chown specify:bi-sp7access fullchain.pem;
```

```bash
sudo systemctl restart nginx.service
#sudo systemctl restart webportal-solr.service
sudo systemctl status webportal-solr.service
```

## specify.ku.edu ssl cert update

uses apache server
```bash
sudo systemctl status httpd.service
sudo ls -la /etc/httpd/conf.d
sudo vim /etc/httpd/conf.d/ipt+specify. # server config file

sudo openssl req -new -newkey rsa:2048 -nodes -keyout specify.ku.edu.key -out specify.ku.edu.csr

# Verify the private key
sudo openssl rsa -in /home/anhalt/ssl/2024/specify_ku_edu.key -check
# Verify the SSL certificate
sudo openssl x509 -in /home/anhalt/ssl/2024/certs/specify_ku_edu_cert.cer -text -noout
# Verify the certificate matches the private key
sudo openssl x509 -noout -modulus -in /home/anhalt/ssl/2024/certs/specify_ku_edu.cer | openssl md5
sudo openssl rsa -noout -modulus -in /home/anhalt/ssl/2024/specify_ku_edu.key | openssl md5
# Check the certificate chain
sudo openssl verify -CAfile /home/anhalt/ssl/2024/certs/specify_ku_edu_interm.cer /home/anhalt/ssl/2024/certs/specify_ku_edu_cert.cer

# Test apache config
sudo httpd -t
sudo systemctl restart httpd
sudo systemctl status httpd
sudo tail -f /var/log/httpd/error_log
```



nevermind, just need to do this, copy the `specify.ku.edu.key` file from the previous year, it remains the same, just need the new `specify_ku_edu_cert.cer` and `specify_ku_edu_interm.cer` files



