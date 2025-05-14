# Exoscale Hosted Instances

We host sensitive data for various Swiss institutions on a secure cloud service known as [Exoscale](https://www.exoscale.com/).

The decision to opt for Exoscale was based on a recommendation from Muséum d'histoire naturelle Geneva. Operating from Switzerland, Exoscale makes sure that the data remains securely within the country's borders, meeting the strict data residency requirements in place by the Swiss government.

To learn about the backup process we use on Exoscale, see [this document](/server_management/exoscale_backups.md).

At the time of writing this (2024-08-14), we manage two compute instances, both in the Geneva zone, both using the `ubuntu` user as the primary account:

## `assets-swiss-1`

This instance is only running an instance of the [web-asset-server](https://github.com/specify/web-asset-server) locally.
The asset server key and other information about the specific configuration is available at `/home/ubuntu/web-asset-server/settings.py`.

### Service Status

You can check the status of the asset server by running the following command:

```sh
ubuntu@assets-swiss-1:~/web-asset-server$ systemctl list-units --type=service | grep web-asset-server
  web-asset-server.service                       loaded active running Specify Web Asset Server
```

### Check the Logs

To view the logs for the asset server, use the following command:

```sh
ubuntu@assets-swiss-1:~/web-asset-server$ journalctl -u web-asset-server.service
```

This command will display the logs related to the `web-asset-server.service`, allowing you to troubleshoot any issues.

### Restarting the Service

If you need to restart the asset server, you can do so with the following command:

```sh
ubuntu@assets-swiss-1:~/web-asset-server$ sudo systemctl restart web-asset-server.service
```

After restarting, you may want to check the status again to ensure it is running properly.

## `sp7cloud-swiss-1`

This server hosts [docker-compositions](https://github.com/specify/docker-compositions/tree/production/specifycloud) specifycloud-style deployments. They are managed in the same manner as the other AWS instances, so no special configuration here.

The `docker-compose.yml` and `spcloudservers.json` files are available at `/home/ubuntu/docker-compositions/specifycloud`.

When changes are made to the `spcloudservers.json` file, run `make` as `ubuntu` to update the appropriate files.