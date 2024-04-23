# Add new Specify instance to Specify Cloud

## Example for <dbname>

1. Create Database
	1. look through the sql file for issues and do test upload to local database
	2. mysql -u<master> -p<master_password> -e "create database <dbname>;"
	3. mysql -u<master> -p<master_password> <dbname> < <dbname>.sql
	4. may need to run `grant all privileges on eurl.* to <master_password>@'%';` if 
       master doesn't have access `flush privileges;`
2. DNS Registtration:
	1. Login to Dreamhost, select Websites -> Manage Websites
	2. For specifycloud.org, select DNS ([Direct link](https://panel.dreamhost.com/index.cgi?tree=domain.dashboard#/site/specifycloud.org/dns))
	3. Add CNAME record that has a name matching the database name and links to the appropraite regional domain value (i.e. `na-specify7-1.specifycloud.org.`, `eu-specify7-1.specifycloud.org.`, etc.). If the database name has underscores (_), replace these with dashes (-).
		- `<dbname>` points to `<subdomain>.specifycloud.org.`
		   For example, database name `herb_rbge` would have the name `herb-rbge.specifycloud.org`.
	4. Wait at least 10 minutes for domain to circulate.
	5. For the ku servers, request the dns CNAME record to bitech@ku.edu
3. Config
	1. Add to `spcloudservers.json` on the appropraite server in the `/home/ubuntu/docker-compositions/specifycloud` dir.
	2. Make sure to add https: false
	3. Run `make` as `ubuntu`
	4. Run `docker compose up -d`
	5. Run `docker compose restart nginx` (reload should be just fine here: `docker exec -it specifycloud_nginx_1 nginx -s reload`)
	6. Check url
4. Add SSL
	1. `mkdir /var/www/unsm-vp`
	2. `certbot --webroot -w /var/www/<subdomain> -d <subdomain>.specifycloud.org certonly`
	3. `certbot certificates`
	4. Remove https: false from spcloudservers.json
	5. `make`
	6. `docker compose up -d`
	7. `docker compose restart`  (maybe just reload instead)
	8. check url
	9. note: after an ssl certificate renewal -> docker exec -it specifycloud_nginx_1 nginx -s reload
		1. For automatic nginx reloading on certificate renewal create /etc/letsencrypt/renewal-hooks/post/reload-nginx.sh `#!/bin/bash docker exec -it specifycloud_nginx_1 nginx -s reload`
		2. `crontab -e;` and then add the line "0 3 * * 0,2,4,6 docker exec specifycloud_nginx_1 nginx -s reload"
		3. `crontab -l` to list cronjobs
5. Add Specify admin credentials to the [master list on the SCC Vault](https://docs.google.com/spreadsheets/d/1saSYJJDJdATwZvzFz873wvC-DkyBQsIQ66un1lpILE4/edit#gid=690980104)
6. Database Backup
	1. ssh into biprdsp6ap.cc.ku.edu
	2. sudo su - spcloudbackup
	3. Add <dbname> into the file /home/spcloudbackup/backup_specify_cloud.py
7. Asset Server
	1. ssh into asset
	2. Add <dbname> directory in attachments directory 'su specify -c "mkdir attachments/<dbname>"' 
	3. Add <dbname> to /home/specify/new-asset-server/settings.py
	4. systemctl restart web-asset-server.service
8. Updown
	1. Add url: <subdomain>.specifycloud.org/context/system_info.json
	2. Add alias: <subdomain>

## Misc

* Add ssh key:

```bash
vim .ssh/authorized_keys
sudo systemctl reload sshd
```

## Troubleshooting 

* Handle mariadb failing to restart after restarting the Database droplet:

```bash
mysqld --tc-heuristic-recover=ROLLBACK
systemctl start mariadb.service
```

* Fix an instance by restarting it:

```bash
sudo docker exec -it specifycloud_nginx_1 nginx -s reload;
sudo docker stop client client-worker;
sudo docker compose up -d;
sudo docker exec -it specifycloud_nginx_1 nginx -s reload;
```
