# Removing a Specify Cloud Instance

Before proceeding with the removal of a Specify Cloud instance, it is crucial to **contact the institution** to ensure they are aware that they have either halted payment to the consortium or that they have switched to self-hosting. We must not destroy or remove any data without providing them a copy. 

Membership staff should be involved before proceeding.

## Steps to Remove a Specify Cloud Instance

1. **Remove from Updown.io**
   - Log in to the Specify [Updown.io](https://updown.io/) account.
   - Locate the instance you wish to remove (e.g., `fishmuseum.specifycloud.org`).
   - Select the instance and click on the option to remove or delete it from your monitoring list. If this is not done before the following steps, we will be notified as if a server went offline.

3. **Remove from `spcloudservers.json`**
   - Access the appropriate Specify Cloud server via SSH.
   - Navigate to the `/home/ubuntu/docker-compositions/specifycloud` directory (should be there automatically).
   - Navigate to the directory: `/home/ubuntu/docker-compositions/specifycloud`.
   - Open the `spcloudservers.json` file in `nano` (or `vim` if you are an expert command line user).
   - Remove the entry corresponding to your Specify Cloud instance and save the changes.

4. **Run `make`**
   - Execute the command:
     ```bash
     make
     ```
   - This will rebuild the necessary configuration files (`docker-compose.yml` and associated resources) without the removed instance as to not accidentally recreate it when building the containers again.

5. **Stop Docker Containers**
   - Identify the names of the Docker containers for the main `specify7` app and the worker.
   - Run the following commands to stop the containers:
     ```bash
     docker stop <name_of_specify7_container>
     docker stop <name_of_worker_container>
     ```
   - Replace `<name_of_specify7_container>` and `<name_of_worker_container>` with the actual container names.

2. **Delete CNAME Record in DreamHost**
   - Log in to our DreamHost account.
   - Navigate to the **Websites** section and select **Manage Domains**.
   - Find the domain associated with your Specify Cloud instance (by default, we use `specifycloud.org`, [link here](https://panel.dreamhost.com/index.cgi?tree=domain.dashboard#/site/specifycloud.org/dns).
   - Click on **Edit** next to the domain and remove the CNAME record (`fishmuseum.specifycloud.org`) for the deployment.

6. **Backup the Database from RDS**
   - Access your AWS RDS console.
   - Locate the database associated with the Specify Cloud instance you are removing (usually the same as the subdomain, with `-` replaced with `_` if included).
   - Create a manual snapshot or export the database to ensure you have a backup before deletion.

7. **Remove the Database from the Server**
   - After backing up the database, proceed to remove it from the server.
   - Ensure that you store the backup safely in the SCC Vault Google Drive under the corresponding member directory for future reference.

8. **Share the Database with the user**
   - Message the point of contact for the insitutiton offering to share the database using any method convenient for them.