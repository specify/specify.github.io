# Spcloud Upgrade

## Upgrade steps

SSH into the server.

Check for user activity, try to wait for at least 15 minutes of no user activity
```bash
docker logs specifycloud-nginx-1 --tail 1000 | grep -v updown | grep -v notification | grep specifycloud.org | awk '{ split($4,time,"["); print time[2], "-", $6, $7, $8, $9, $10, $11; }'
```

Check which instances are running and the state of the resources for the server
```
docker ps;
glances;
```

Pull the new docker image
```bash
docker pull specifyconsortium/specify7-service:v7.10.2;
```

Edit the `spcloudservers.jsoh` file.  For the clients that need upgrading, edit their version to the new version

Run the make command
```bash
make;
```

Verify that the `docker-compose.yml` and `nginx.conf` files look good, no obvious errors and the environment settings look correct.

Test the new nginx config
```bash
docker exec -it specifycloud-nginx-1 nginx -t
```

When upgrading the majority of instances, run this
```
docker compose down; docker compose up -d;
```

When only upgrading one, or a few instances, run this
```bash
docker compose up -d sp7demofish sp7demofish-worker;
```

Check the status of the instances as the are rebuilding and starting up.  Need to monitor closely when doing large migration changes
```bash
docker logs --follow specifycloud-sp7demofish-1
```

Recheck the running status of the instances and server state
```bash
docker ps;
glances;
```

Check a samlple of the instance urls in the browser to make sure they are running well.  For a sample of them, make sure there are no errors when logging in.

If there are errors after running, or if there are migration issues, try to resolve in a timely manner.

Check migration status
```bash
docker exec specifycloud-sp7demofish-1 ve/bin/python manage.py showmigrations;
```
