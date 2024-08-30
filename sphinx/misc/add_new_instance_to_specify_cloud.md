# Add new Specify instance to Specify Cloud

## Example for <dbname>

1. Create Database
	1. Review the SQL file before importing to the production server. Test the import locally before uploading to a production instance.
	2. Ensure the new database has the same name as the subdomain the user wishes to use, remembering that underscores (`_`) are replaced with dashes (`-`) for the URL.
	3. Create the database:
		```sql
		mariadb -u<master> -p<master_password> -e "CREATE DATABASE <dbname>;"
		```
	4. Upload and restore the existing database:
		```
		mariadb -u<master> -p<master_password> <dbname> < <dbname>.sql
		```
	4. **Note:** You may `GRANT ALL PRIVILEGES ON <dbname>.* TO <master_password>@'%';` if 
       master doesn't have access `FLUSH PRIVILEGES;`
2. DNS Registration:
	1. Login to Dreamhost, select Websites -> Manage Websites
	2. For `specifycloud.org`, select DNS ([Direct link](https://panel.dreamhost.com/index.cgi?tree=domain.dashboard#/site/specifycloud.org/dns))
	3. Add CNAME record that has a name matching the database name and links to the appropraite regional domain value (i.e. `na-specify7-1.specifycloud.org.`, `eu-specify7-1.specifycloud.org.`, etc.). If the database name has underscores (_), replace these with dashes (-).
		- `<dbname>` points to `<subdomain>.specifycloud.org.`
		   For example, database name `herb_rbge` would have the name `herb-rbge.specifycloud.org`.
	4. Wait at least 10 minutes for domain to circulate.
	5. For the ku servers, request the dns CNAME record to bitech@ku.edu
3. Config
	1. Add to `spcloudservers.json` on the appropriate server in the `/home/ubuntu/docker-compositions/specifycloud` dir.
	2. Make sure to add https: false
	3. Run `make` as `ubuntu`
	4. Run `docker compose up -d`
	5. Run `docker compose restart nginx` (reload should be just fine here: `docker exec -it specifycloud_nginx_1 nginx -s reload`)
	6. Check url
4. Add SSL
	1. Run the `add_ssl.sh` script and follow the prompts.
	   ```bash
		sudo bash add_ssl.sh
	   ```
	   You will need to provide the `<subdomain>` for the new instance that you wish to add. After this, it will update the `spcloudservers.json` and set `"https": false` to `"https": true` for that instance, then restart all of the running containers.
	8. Check URL
	9. **Note:** After an SSL certificate renewal, you can reload nginx without restarting the whole container: 
	    ```bash
		docker exec -it specifycloud-nginx-1 nginx -s reload
		```
		1. For automatic nginx reloading on certificate renewal create /etc/letsencrypt/renewal-hooks/post/reload-nginx.sh `#!/bin/bash docker exec -it specifycloud_nginx_1 nginx -s reload`
		2. `crontab -e;` and then add the line `0 3 * * 0,2,4,6 docker exec specifycloud_nginx_1 nginx -s reload`
		3. `crontab -l` to list cronjobs
5. Add Specify Admin user credentials to the Bitwarden Vault
6. Setup attachments for the database
	1. SSH into the appropriate Web Asset Server
	2. Navigate to the `web-asset-server` directory
	2. Use the `manage_collection_dirs.py` utility to add the new database(s) to the server:
		```
		python3 manage_collection_dirs.py add <database_name>
		```
	    This creates a new attachemnt directory and updates the `settings.py` file to add the collection directory.
7. Updown
	1. Add url: `<subdomain>.specifycloud.org/context/system_info.json`
	2. Add alias: `<subdomain>`

## Misc

* Add ssh key:

```bash
nano .ssh/authorized_keys
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
sudo docker exec -it specifycloud-nginx-1 nginx -s reload;
sudo docker stop client client-worker;
sudo docker compose up -d;
sudo docker exec -it specifycloud-nginx-1 nginx -s reload;
```
