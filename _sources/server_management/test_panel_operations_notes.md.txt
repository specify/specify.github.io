# Test-Panel Operation Notes

view nginx file
```bash
docker exec -it specify7-test-panel-panel-1 cat /home/node/nginx.conf.d/nginx.conf
```
or
```bash
docker exec -it specify7-test-panel-panel-1 cat /etc/nginx/conf.d/servers/nginx.conf
```
or
```bash
sudo vim /var/lib/docker/volumes/specify7-test-panel_nginx-conf/_data/nginx.conf
```


view currently deployed docker-compose.yml
```bash
docker exec -it specify7-test-panel-panel-1 cat /home/node/state/docker-compose.yml
```
or
```bash
sudo vim /var/lib/docker/volumes/specify7-test-panel_state/_data/docker-compose.yml
```

view current instance configuration
```bash
docker exec -it specify7-test-panel-panel-1 cat /home/node/state/configuration.json
```
or
```bash
sudo vim /var/lib/docker/volumes/specify7-test-panel_state/_data/configuration.json
```

Fix SSL cert problem
```bash
cp -r test.specifysystems.org-0001/ test.specifysystems.org/
```
or
```bash
sudo cp -r /etc/letsencrypt/live/test.specifysystems.org-0001/
```

`/etc/letsencrypt/live/test.specifysystems.org/`

Docker build
```
sudo docker compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  up --no-start --build
```
or
```
sudo docker compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  build
```

Docker run
```
sudo docker compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  -f /var/lib/docker/volumes/specify7-test-panel_state/_data/docker-compose.yml \
  up --remove-orphans -d
```

Restart
```
sudo docker compose down; sudo docker compose -f docker-compose.yml -f docker-compose.production.yml -f /var/lib/docker/volumes/specify7-test-panel_state/_data/docker-compose.yml up --remove-orphans -d
```

Docker stop
```bash
sudo docker stop $(sudo docker ps --all -q)
```

Full stop, rebuild, and restart
```bash
sudo docker stop $(sudo docker ps --all -q);
sudo docker rm $(sudo docker ps --all -q);
sudo docker compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  up --no-start --build;
sudo docker compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  -f /var/lib/docker/volumes/specify7-test-panel_state/_data/docker-compose.yml \
  up --remove-orphans -d;
```

full stop and restart without rebuild
```bash
sudo docker compose down;
sudo docker stop $(sudo docker ps --all -q);
sudo docker rm $(sudo docker ps --all -q);
sudo docker compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  -f /var/lib/docker/volumes/specify7-test-panel_state/_data/docker-compose.yml \
  up --remove-orphans -d;
```

Check SPECIFY_THICK_CLIENT
```
docker exec -it specify7-test-panel-geo20241205-production-2-1 bash
ve/bin/python manage.py shell
from django.conf import settings
settings.SPECIFY_THICK_CLIENT
```
or
```bash
docker exec specify7-test-panel-_-1 ve/bin/python -c "from django.conf import settings; print(settings.SPECIFY_THICK_CLIENT)"
```

```bash
docker exec -it specify7-test-panel-<_name>-1 ve/bin/python -c "from django.conf import settings; import; if os.path.exists('/opt/specify7/config') : settings.SPECIFY_THICK_CLIENT='/opt/specify7')
```

```bash
#!/bin/bash

# Get all running container names
all_containers=$(docker ps --format "{{.Names}}")

# Filter out unwanted containers
filtered_containers=$(echo "$all_containers" | grep -vE '(panel-panel|redis|nginx)')

# Loop through filtered containers and execute the command
while IFS= read -r container_name; do
    echo "Processing container: $container_name"
    
    # Execute the command inside the container using multiline syntax
    docker exec $container_name ve/bin/python <<EOF
from django.conf import settings
import os
if os.path.exists('/opt/specify7/config'):
    settings.SPECIFY_THICK_CLIENT = '/opt/specify7'
EOF
    
    echo "Finished processing $container_name"
done <<< "$filtered_containers"

echo "All containers processed."

```

SSL renewal (not sure yet) - need to get 'etc/letsencrypt/live/test.specifysystems.org' directory to match /etc/letsencrypt/live/test.specifysystems.org-0001

```bash
ls -la /etc/letsencrypt/live/test.specifysystems.org;
ls -la /etc/letsencrypt/live/test.specifysystems.org-0001;
ls -la /etc/letsencrypt/archive/test.specifysystems.org-0001;

sudo rm /etc/letsencrypt/live/test.specifysystems.org-0001/fullchain.pem;
sudo ln -s /etc/letsencrypt/archive/test.specifysystems.org-0001/fullchain6.pem /etc/letsencrypt/live/test.specifysystems.org-0001/fullchain.pem;

sudo rm /etc/letsencrypt/live/test.specifysystems.org-0001/privkey.pem;
sudo ln -s /etc/letsencrypt/archive/test.specifysystems.org-0001/privkey6.pem /etc/letsencrypt/live/test.specifysystems.org-0001/privkey.pem;

sudo rm /etc/letsencrypt/live/test.specifysystems.org-0001/chain.pem;
sudo ln -s /etc/letsencrypt/archive/test.specifysystems.org-0001/chain6.pem chain.pem;

sudo rm /etc/letsencrypt/live/test.specifysystems.org-0001/cert.pem;
sudo ln -s /etc/letsencrypt/archive/test.specifysystems.org-0001/cert6.pem cert.pem;

docker exec -it specify7-test-panel-nginx-1 nginx -s reload;
```

```bash
# Change the ssl files nginx points to
sudo ln -sf /etc/letsencrypt/archive/test.specifysystems.org-0001/cert6.pem /etc/letsencrypt/live/test.specifysystems.org/cert.pem;
sudo ln -sf /etc/letsencrypt/archive/test.specifysystems.org-0001/chain6.pem /etc/letsencrypt/live/test.specifysystems.org/chain.pem;
sudo ln -sf /etc/letsencrypt/archive/test.specifysystems.org-0001/fullchain6.pem /etc/letsencrypt/live/test.specifysystems.org/fullchain.pem;
sudo ln -sf /etc/letsencrypt/archive/test.specifysystems.org-0001/privkey6.pem /etc/letsencrypt/live/test.specifysystems.org/privkey.pem;
docker exec -it specify7-test-panel-nginx-1 nginx -s reload;
```

### Check instance migration state
find container name
`docker stats --no-stream`

bash into container
`docker exec -it <container_name> bash`

see migration state
`ve/bin/python manage.py showmigrations`

# Test static file access for an instance

Create test config file for an instance:
```bash
touch config/test.txt;
echo "Testing" > config/test.txt;
```

request:
```bash
curl https://ojsmnh110242024prod-production.test.specifysystems.org/static/config/icons_datamodel.xml

curl https://ojsmnh110242024prod-production.test.specifysystems.org/static/config/test.txt

curl https://ojsmnh110242024prod-production.test.specifysystems.org/static/config/geology/geology.views.xml

curl https://sandbox-rbge.specifycloud.org/context/view.json?name=CollectionObjectGroup
```

test config
```
ve/bin/python manage.py shell

from django.conf import settings
settings.SPECIFY_CONFIG_DIR
```

view all django. settings
```python
from django.conf import settings; print("\n".join(f"{setting}: {getattr(settings, setting)}" for setting in dir(settings) if setting.isupper()))
```

```bash
ve/bin/python manage.py shell -c 'from django.conf import settings; print("\n".join(f"{setting}: {getattr(settings, setting)}" for setting in dir(settings) if setting.isupper()))'
```

vim command
```
%s/THICK_CLIENT_LOCATION/SPECIFY_CONFIG_DIR/g

%s/volumes:\n\s\s\s\s\s\s\n/volumes:\n\s\s\s\s\n/g
	```
