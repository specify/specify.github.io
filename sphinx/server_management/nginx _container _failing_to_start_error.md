If the nginx container fails to start, here are some steps.

First I inspected the spcloudservers.json, nginx.conf, and docker-compose.yml files for any issues or misconfigurations.

```bash
vim spcloudservers.json;
vim nginx.conf;
vim docker-compose.yml;
```

check the docker logs:
```bash
docker logs specifycloud-nginx-1 --tail 1000
```

I saw an error like this
```
2025/05/07 06:54:50 [emerg] 1#1: cannot load certificate "/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem": BIO_new_file() failed (SSL: error:80000002:system library::No such file or directory:calling fopen(/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem, r) error:10000080:BIO routines::no such file)
nginx: [emerg] cannot load certificate "/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem": BIO_new_file() failed (SSL: error:80000002:system library::No such file or directory:calling fopen(/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem, r) error:10000080:BIO routines::no such file)
/docker-entrypoint.sh: /docker-entrypoint.d/ is not empty, will attempt to perform configuration
/docker-entrypoint.sh: Looking for shell scripts in /docker-entrypoint.d/
/docker-entrypoint.sh: Launching /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh
10-listen-on-ipv6-by-default.sh: info: can not modify /etc/nginx/conf.d/default.conf (read-only file system?)
/docker-entrypoint.sh: Sourcing /docker-entrypoint.d/15-local-resolvers.envsh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/20-envsubst-on-templates.sh
/docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
/docker-entrypoint.sh: Configuration complete; ready for start up
2025/05/07 06:55:50 [emerg] 1#1: cannot load certificate "/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem": BIO_new_file() failed (SSL: error:80000002:system library::No such file or directory:calling fopen(/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem, r) error:10000080:BIO routines::no such file)
nginx: [emerg] cannot load certificate "/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem": BIO_new_file() failed (SSL: error:80000002:system library::No such file or directory:calling fopen(/etc/letsencrypt/live/ncfish.specifycloud.org/fullchain.pem, r) error:10000080:BIO routines::no such file)
```

After inspecting, it seemed that the cert files were not there any longer, strange, but can be fixed by following the SSL sert steps.

First, get the nginx.conf file working again by editing the config in spcloudservers.json, set the https to false.
```json
    "ncfish": {
      "database": "ncfish",
      "env": {
        "ASSET_SERVER_URL": "https://assets-test.specifycloud.org/web_asset_store.xml"
      },
      "sp7": "v7.10.2.2",
      "sp6": "specify6803",
      "https": false
    },
```

```bash
docker compose up -d
```

```bash
ls -la /etc/letsencrypt/live/;
sudo mkdir /var/www/ncfish;
sudo certbot --webroot -w /var/www/ncfish -d ncfish.specifycloud.org certonly
```

change the https back to `True` again

validate and reload nginx
```bash
docker exec -it specifycloud-nginx-1 nginx -t;
docker exec -it specifycloud-nginx-1 nginx -s reload;
```

check that everything is running well
```bash
docker ps;
docker stats --no-stream;
docker logs specifycloud-nginx-1 --tail 1000;
curl https://ncfish.specifycloud.org;
```


