## Updown Monitoring

We use a service called [updown.io](https://updown.io/) to monitor our websites and uptime. It allows our users (and our staff) to monitor the availability and performance of hosted instances. It checks the sites regularly from a number of locations and provides notifications on **Slack** ([#updown-monitoring channel](https://specifydev.slack.com/archives/C04AM8WSM89)) and via **Email** in case of any downtime or issues.

**Login:** [updown.io – Website monitoring, simple and inexpensive](https://updown.io/checks)

**Username:** [support@specifysoftware.org](mailto:support@specifysoftware.org)
  

### Public Status Pages

* [KU Specify 7 Web Servers](https://updown.io/p/mug6t)
* [All Specify Monitored Servers](https://updown.io/p/8g4mg)
* [Digital Ocean access](https://updown.io/p/8g4mg)


We check the Specify 7 deployments by verifying that the `example.specifycloud.org/context/system_info.json` file is accessible as it does not require authentication to view.

### Known Issues

* If Specify 6 static files become inaccessible to Specify 7, Specify 7 no longer functions properly. Updown does not have any way of verifying this, which has resulted in downtime for users without any notification.

  

## Managed Servers

### KUIT Managed Servers

  

We have a document that outlines the purpose and function of each of the BI Informatics servers: [**KUIT Managed Physical and Virtual Servers**](https://docs.google.com/document/d/1XiYl4KKekCPjWMR7GbkXGpXdijiZ1C_KrtptEzapgy4/edit)
  

### Specify X (Wordpress, Taxon files, Specify 6 downloads, etc.)

**Host Name:** [Link](https://docs.google.com/document/d/11rnM0v5ytBQTxlutuAYEsTkpcmJpo23n6l7hR3YHFKw/edit)

**Platform:** DreamHost

**Backups?:** Yes
 
This server does not often require us to access or make any changes. At this time, we update this periodically to add new versions of Specify 6, update default taxonomy files that the Specify 6 wizard and application use to generate new trees, and make changes to our Wordpress sites.
 
The server covers the following:
  
* specifysoftware.org (Wordpress)
* specifysoftware.com (Domain alias)
* specify6.specifysoftware.com (Domain alias)
* files.specifysoftware.com (Domain alias)
* specifycloud.org (Wordpress)
* files.specifysoftware.org
   * (Static files, such as Specify 6 installers, taxon files that the Specify Wizard uses, Wordpress site files and images, Wordpress backups, old documentation, etc. You can see all of the [important files contained within here](https://files.dreamhost.com/#/c/75.119.218.42/specifyx/eyJ0Ijoic2Z0cCIsImMiOnsidiI6MCwicCI6IkNvdXNzYXJlYTJkaW9pY2EhIiwicyI6MCwibSI6IlBhc3N3b3JkIn19))
* update.specifysoftware.org
   * (This is the place Specify 6 looks to see if an update is available. There is an XML file we edit to indicate a new release has launched)
* sustain.specifysoftware.org
   * (This is a link to the main website, but this is also the name of the directory that stores all of the Wordpress site files)

  

### Test Panel

**Host Name:** test.specifysystems.org ([Link](https://docs.google.com/document/d/11rnM0v5ytBQTxlutuAYEsTkpcmJpo23n6l7hR3YHFKw/edit#heading=h.4ca8dydxjfft))
**Platform:** DigitalOcean
**Backups?:** No

Available at [https://test.specifysystems.org/](https://test.specifysystems.org/) for users in the Specify GitHub organization.


This server hosts the Specify 7 Test Panel used for internal testing and for deploying evaluation databases for prospective users. The application deployed on this server is described in the [specify7-test-panel repository](https://github.com/specify/specify7-test-panel).

  

It is installed in the `/home/specify/specify7-test-panel` directory. Make sure to **switch to this directory** before running any of the commands below.

If the server becomes unavailable or goes offline, you can build and run all the containers by running the following commands:

Build the containers:
```bash
docker-compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  up --no-start --build
```

Run the containers:
```bash
docker-compose \
  -f docker-compose.yml \
  -f docker-compose.production.yml \
  -f /var/lib/docker/volumes/specify7-test-panel_state/_data/docker-compose.yml \
  up --remove-orphans -d
```

The `configuration.json` file (located at `/var/lib/docker/volumes/specify7-test-panel_state/_data/configuration.json`) is the file that is written to when changes are made to the deployments on the front-end. This file is then used to make the `docker-compose.yml` which defines the deployments.

You can modify either file by using `nano` , but remember that `configuration.json` will dictate how the `docker-compose.yml` file is built once changes are made. Any changes directly to the compose file will be overwritten when users make a change on the front-end.

Keep in mind that any change done in the UI of the test panel or new automatic deployments will overwrite these customizations, so this is only useful for short-term testing (testing new asset server, special configurations).

#### Known Issues:
* Don’t run out of storage. Cannot access anymore when that happens.
* Pull requests on the Specify 7 repository that attempt to merge `production` into a branch will auto-deploy an instance that takes down the test panel ([#102](https://github.com/specify/specify7-test-panel/issues/102))
   * To resolve this, you need to remove the PR from the repository. To fix this, we need to modify the test server code to substitute that in the response received from the GitHub API (when fetching pull requests).
* If a database has a version of Specify 6 that isn't dockerized, it will break the panel. You will need to manually remove the deployment and database.
  

### Web Portal

  

**Host Name:** webportal.specifysystems.org ([Link](https://docs.google.com/document/d/11rnM0v5ytBQTxlutuAYEsTkpcmJpo23n6l7hR3YHFKw/edit#heading=h.4ca8dydxjfft))

**Platform:** DigitalOcean

**Backups?:** No

  

This server hosts the [webportal-installer](https://github.com/specify/webportal-installer/tree/improve-build) app for Specify Cloud users. This is an additional membership fee so only a select number of cloud users have a portal configured.

  

The main Web Portal dependencies are the latest version of Solr 7.5 and Python 2.7 ([see all here](https://github.com/specify/webportal-installer?tab=readme-ov-file#install-system-dependencies)). Both here at the SCC and externally, this is most often installed locally, although a Docker version does exist. On this server, it is installed in the `/home/specify/webportal-installer` directory.

  

Inside of this directory are the following important subdirectories:

  

*  `specify_exports` (where you put the exports from the DataExporter application)
*  `custom_settings` (where you define custom settings for each Web Portal instance)

  

I’ve written more advanced configuration instructions for use when setting up `custom_settings` here on the Speciforum: [Configuration Instructions](https://discourse.specifysoftware.org/t/web-portal-configuration-instructions/1144)

  

You can reload customizations to existing deployments by running `make build-html` without having to restart any other services ([source](https://github.com/specify/webportal-installer?tab=readme-ov-file#full-updates)).

  

#### Update Instructions

  

* [Instructions on running data-only updates to Web Portal instances](subdirectories)
* [Instructions on running full updates for Web Portal instances](https://github.com/specify/webportal-installer?tab=readme-ov-file#full-updates)

  

#### Accessing Web Portals

  

You can see a list of all currently hosted Web Portal instances here:

  

[https://webportal.specifycloud.org/](https://webportal.specifycloud.org/)

  

The URL is appended with the export name when a web portal instance is created. For instance, the `specify_exports` directory contains an export for the University of Washington Fish Collection named `uwfc.zip`. After creating a Web Portal instance for them, it becomes accessible at [https://webportal.specifycloud.org/uwfc/](https://webportal.specifycloud.org/uwfc/).

On [June 12, 2024, I hosted an internal demo](https://docs.google.com/document/d/1QXpWFf9U4lzqVLwC7BJkG_PFWqENCDlEOmWUUsUA0X8/edit?usp=sharing) discussing the function of the Web Portal and the details involved in data exporting and portal configuration. Regular use instructions are available on the [webportal-installer](https://github.com/specify/webportal-installer/blob/improve-build/README.md) repository and other documentation about [exporting is available on the forum](https://discourse.specifysoftware.org/t/staff-solution-web-portal-refresh/1785).

  

#### Backups
No backups are made of this server at this time.

  

### Assets for Specify Cloud

  

**Host Name:** assets1.specifycloud.org ([Link](https://docs.google.com/document/d/11rnM0v5ytBQTxlutuAYEsTkpcmJpo23n6l7hR3YHFKw/edit#heading=h.4ca8dydxjfft))

**Platform:** AWS
**Backups?:** Yes

*TODO: This description was written when the assets were hosted on DigitalOcean– these should be revisited once the migration to AWS is complete*

This server hosts an installation of the Specify [web-asset-server](https://github.com/specify/web-asset-server). The application is installed to `/home/specify/web-asset-server-new` but the originals and thumbnails generated by Specify are stored in the `/home/specify/attachments` directory.

  

In the `attachments` directory, there are subdirectories for each database that we have configured. In those directories there are two folders, `originals` and `thumbnails`. One contains the original images and the other contains the thumbnails generated by Specify automatically.

  

#### Backups

DigitalOcean assets are/were backed up to the following location on the Specify ResFS drive:

`smb://resfs.home.ku.edu/GROUPS/BI/Specify/Specify7/SpecifyCloudBackups/assets`

  

### Assets for Test Panel & Demo Database Instance

  

**Host Name:** assets-test.specifycloud.org ([Link](https://docs.google.com/document/d/11rnM0v5ytBQTxlutuAYEsTkpcmJpo23n6l7hR3YHFKw/edit#heading=h.4ca8dydxjfft))
**Platform:** AWS
**Backups?:** No

This server hosts an installation of the Specify [web-asset-server](https://github.com/specify/web-asset-server). The application is installed to `/home/ubuntu/web-asset-server` but the originals and thumbnails generated by Specify are stored in the `/home/ubuntu/attachments` directory.

  

In the `attachments` directory, there are subdirectories for each database that we have configured. In those directories there are two folders, `originals` and `thumbnails`. One contains the original images and the other contains the thumbnails generated by Specify automatically.

  

The databases on the Test Panel and the [sp7demofish](https://sp7demofish.specifycloud.org/specify/) instance upload images to the `/home/ubuntu/attachments/sp7demofish` directories.

  

Backups for this server are handled by AWS.

  

#### Known Issues

  

* This server has intermittent availability and can randomly become inaccessible. The issue arises because it is hosted on AWS using a 'spot instance'.

* It has been known to occasionally stop working without any notice. To resolve this, we have had to restart the `web-asset-server` service. See more [research done in Slack here](https://specifydev.slack.com/archives/CC6V12D3J/p1699902819872219).

  

### Specify Cloud Instances

  

**Host Name:** ([Link](https://docs.google.com/document/d/11rnM0v5ytBQTxlutuAYEsTkpcmJpo23n6l7hR3YHFKw/edit#heading=h.4ca8dydxjfft))
   - na-specify7-1.specifycloud.org (North America)
   - eu-specify7-1.specifycloud.org (Europe)
   - ca-specify7-1.specifycloud.org (Canada)
   - il-specify7-1.specifycloud.org (Israel)
   - br-specify7-1.specifycloud.org (Brazil)
   - swiss-specify7-1.specifycloud.org (Switzerland)

**Platform:** AWS
  
  

Specify Cloud instances mirror each other in configuration. All have Docker installed via `apt`, not `snap`.  Important distinction.

The directory that contains the configuration files for the Specify 7 deployments using Docker is `/home/ubuntu/docker-compositions/specifycloud`.
  
  You can read more about the specific configuration details here in the [docker-compositions/specifycloud repository](https://github.com/specify/docker-compositions/tree/production/specifycloud).

In here, there is a file named `spcloudservers.json` that allows you to configure specific environment variables for certain deployments. The most common variables are the Specify 7 and Specify 6 version, but you can also specify an asset server URL, asset server key, anonymous (guest) user for the deployment, or several other environmental settings.
  

**Example `spcloudservers.json` file:**
```json
{
    "servers": {
        "sp7demofish-eu": {
            "env": {
                "ASSET_SERVER_URL": "https://assets-test.specifycloud.org/web_asset_store.xml"
            },
            "sp7": "v7",
            "sp6": "specify6803"
        },
        "rjb-madrid": {
            "sp7": "v7",
            "sp6": "specify6803",
            "env": {
                "ASSET_SERVER_URL": "",
                "ASSET_SERVER_COLLECTION": "Fanerogamia"
            }
        },
        "mcnb": {
            "sp7": "v7",
            "sp6": "specify6803"
        },
        "herb-rbge": {
            "sp7": "v7",
            "sp6": "specify6803",
            "settings_file": "./settings/herb-rbge-settings.py"
        }
    },

    "sp6versions": {
        "specify6800": "6.8.00",
        "specify6801": "6.8.01",
        "specify6803": "6.8.03"
    },

    "decommissioned": []
}
```
  

You can modify the version of a particular Specify 7 instance by changing `v7` (or the currently configured tag) to any tag available on the [specify7-service DockerHub repository](https://hub.docker.com/repository/docker/specifyconsortium/specify7-service/general).

  

The Specify 6 version (this controls the static Specify 6 files accessible to the Specify 7 installation) can be changed from here as well to pull from any tag in the [specify6-service DockerHub repository](https://hub.docker.com/repository/docker/specifyconsortium/specify6-service/general).
  

### Updating Specify 7 Instances

After making **any** changes to the `spcloudservers.json` file, you will need to run `make` to update the script that updates the following resources:

```
docker-compose.yml 
nginx.conf 
sp7setup-all.sh
```

Assuming all instances are configured to use the Docker tag `v7` in the `spcloudservers.json` file, you can simply run the following command in the `/home/ubuntu/docker-compositions/specifycloud` directory:

```bash
docker pull specifyconsortium/specify7-service:v7
```

*Note: You can pull [any valid Dockerhub tag](https://hub.docker.com/repository/docker/specifyconsortium/specify7-service/tags) for `specify7-service` given that it is build for ARM*

After this, you can run the `sp7setup-all.sh` script in the same directory to automatically update all deployments on the server.

```
sh sp7setup-all.sh
```

This script just runs `docker-compose up -d {instance_name} {instance_name_worker}` to automatically compose all of the Specify 7 instances along with their accompanying worker process.

  

#### Troubleshooting

  

If a user is encountering an issue, you can check the logs of each container by running the following commands:

  

1. Run `docker ps`.

This will give you a list of all running Docker instances. From here, you can see the container IDs, image names, timestamp created, status, ports, and the container names.

1. You can run `docker logs --tail 1000 specifycloud-{instancename}-1` to see the last 1000 lines in the Docker logs for a given instance.

If you are troubleshooting a WorkBench-related issue, you should do the same except look at the logs for the `-worker-1` container instead.

1. If you want to see Specify 7 activity, you can look at the logs for the nginx container.

This can be done by running `docker logs --tail 1000 specifycloud-nginx-1`. You can use `grep` to find specific instance information or to look for specific activity for a given deployment.

  

You can use `docker restart` or other Docker command-line tools to manage these instances as needed.

  

To enter into a container, you can run the following (remove the brackets when inserting the container ID from Docker):

  

Inside the container you can examine the Specify 7 files and perform actions like re-running migrations.

  

**For example:** You can run this inside of a Specify 7 docker container to re-run the Agent Merging migrations in case there was an issue during the initial migration:

 
  

## Accessing Specify 7 Deployments

To access a particular instance, you can go to the database name (replace any underscore (`_`) with a dash (`-`) + specifycloud.org. The names of each database can be found in the spreadsheet or on the regional database server for each respective region.

For instance, the Specify Cloud deployment for the database `lsumz_mammals` is accessible at `lsumz-mammals.specifycloud.org`. The database `fwri` is accessible at `fwri.specifycloud.org`.

###  Access a Specify Database without a Password

>**Note:** This text is intended for educational purposes only. Accessing a database without the proper authorization is not only unethical, but it is also strictly prohibited by our employment policies. This action should only be taken when absolutely necessary, and accessing deployments without the appropriate permission is grounds for termination.

**This requires direct SQL edit access to the `specifyuser` table outside of Specify**.

If we cannot gain access to a Specify deployment, we can edit the `specifyuser` table directly to modify the password of an existing user. You can update the password in plain text using SQL.

Once you log in using Specify 6, it will be hashed, and then that user can be accessed in Specify 7 as well. Specify 7 will not allow you to log in if the password is not hashed, so this must be done first in Specify 6.
  
To set the password to ‘testuser’ for any hosted deployment, you can run the following:

```sql
UPDATE specifyuser SET Password = 
'EC62DEF08F5E4FD556DAA86AEC5F3FB0390EF8A862A41ECA'
WHERE SpecifyUserID = 0;
```

You can alternatively copy the hash of another user's password that you know over the user you cannot access.

Replace `0` with the appropriate `SpecifyUserID`. You can replace the password with the user’s original hashed password string after performing the necessary schema updates.

## Accessing Backups on AWS RDS

1. Login to the AWS web console and select the appropriate region.

2. Select RDS, and select the database instance you are looking for backups of.

3. Select the “Maintenance & Backups” tab, and scroll down to “snapshots”.

4. Select the snapshot you want to restore by date, and then press the “Restore” button.

5. In the “Restore snapshot” settings, pick a small instance type like “db.t3.small”. All the other settings should be ok by default. Scroll to the bottom and click the “Restore DB Instance”

6. Once the new database is up and running, select the instance, click on “Actions” and then click “Setup EC2 Connection”. You will want to choose the EC2 instance that you have connected to your production database.

7. SSH into your EC2 instance and use mysql commands to download the client’s snapshot database and upload it to the production database.

1.  `mysqldump -h <db\_host> -u <db\_user> -p <password> <client\_database> > <file>.sql`

2.  `mysql -h <db\_host> -u <db\_user> -p <password> <client\_database> < <file>.sql`

8. If you want to restore a snapshot from more than a month ago, then you will find those snapshots in the S3 backups bucket.