# Add new Specify instance to Specify Cloud

## Example for UNSM_VP

1. Create Database
	1. look through the sql file for issues and do test upload to local database
	2. mysql -umaster -p'master' -e "create database unsm_vp;"
	3. mysql -umaster -p'master' unsm_vp < unsm_vp.sql
	4. may need to run `grant all privileges on eurl.* to 'master'@'%';` if master doesn't have access `flush privileges;`
2. DNS Registtration:
	1. Login to Dreamhost, select Websites -> Manage Websites
	2. For specifycloud.org, select DNS
	3. Add CNAME record in the style of the other users.
		4. `unsm-vp` points to `na-specify7-1.specifycloud.org.`
	4. Wait at least 10 minutes for domain to circulate.
	5. For the ku servers, request the dns CNAME record to bitech@ku.edu
3. Config
	1. Add to spcloudserver.json
	2. Make sure to add https: false
	3. su specify -c make
	4. docker-compose up -d
	5. docker-compose restart nginx (actually just reload is fine here: docker exec -it specifycloud_nginx_1 nginx -s reload)
	6. check url
4. Add SSL
	1. mkdir /var/www/unsm-vp
	2. certbot --webroot -w /var/www/unsm-vp -d unsm-vp.specifycloud.org certonly
	3. certbot certificates
	4. Remove https: false from spcloudserver.json
	5. su specify -c make
	6. docker-compose up -d
	7. docker-compose restart  (maybe just reload instead)
	8. check url
	9. note: after an ssl certificate renewal -> docker exec -it specifycloud_nginx_1 nginx -s reload
		1. For automatic nginx reloading on certificate renewal create /etc/letsencrypt/renewal-hooks/post/reload-nginx.sh `#!/bin/bash docker exec -it specifycloud_nginx_1 nginx -s reload`
		2. crontab -e; and then add the line "0 3 * * 0,2,4,6 docker exec specifycloud_nginx_1 nginx -s reload"
		3. crontab -l to list cronjobs
5. Database Backup
	1. ssh into biprdsp6ap.cc.ku.edu
	2. sudo su - spcloudbackup
	3. Add unsm_vp into the file /home/spcloudbackup/backup_specify_cloud.py
6. Asset Server
	1. ssh into asset
	2. Add unsm_vp directory in attachments directory 'su specify -c "mkdir attachments/unsm_vp"' 
	3. Add unsm_vp to /home/specify/new-asset-server/settings.py
	4. systemctl restart web-asset-server.service
7. Updown
	1. Add url: unsm-vp.specifycloud.org/context/system_info.json
	2. Add alias: unsm-vp

# Misc

* Add ssh key:

```bash
vim .ssh/authorized_keys
sudo systemctl reload sshd
```

# Troubleshooting 

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
