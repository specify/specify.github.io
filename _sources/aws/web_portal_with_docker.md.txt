# Web Portal with Docker

We are managing our Web Portal instances using a Docker image on EC2.

## Deployment

You can connect using the `ubuntu` user to the EC2 instance. In the instance, there is a `docker-compose.yml` file.

This file sets up a Web Portal service that runs on a single container with the following key components:

### What it does:
- Runs a web portal application in a Docker container named "webportal"
- Serves web traffic on both HTTP (port 80) and HTTPS (port 443)
- Manages multiple client portals for different organizations/museums

### Key features:
- SSL/HTTPS support with Let's Encrypt certificates
- Custom configurations for different client portals
- File exports from Specify databases stored as ZIP files
- Custom branding with client-specific images and settings
- Auto-restart if the container fails

### Volume mounts:
The container connects several directories from the host machine (under `/home/ubuntu/`):

- **Project files** - the main web portal application code
- **SSL certificates** - for HTTPS encryption
- **Client exports** - database exports for each portal (ZIP files)
- **Custom settings** - portal-specific configurations
- **Custom images** - client branding and logos

These should **not** be edited from within the container.

```yml
services:
  webportal:
    build:
      context: .
      dockerfile: Dockerfile
    image: webportal-service:improve-build
    container_name: webportal
    ports:
      - "80:80"
      - "443:443"
    volumes:
      # Project files
      - ./webportal-installer:/home/specify/webportal-installer

      # SSL and certs
      - /etc/letsencrypt/live/webportal.specifycloud.org:/etc/nginx/ssl
      - /etc/letsencrypt:/etc/letsencrypt
      - /etc/ssl/certs/dhparam.pem:/etc/ssl/certs/dhparam.pem

      # Static content
      - /var/www:/var/www

      # Specify exports and customizations
      - ./specify_exports:/home/specify/webportal-installer/specify_exports
      - ./custom_settings:/home/specify/webportal-installer/custom_settings

      # Custom images
      - ./custom-images:/home/specify/

    restart: unless-stopped
```

The server structure should look something like this:

```bash
.
├── custom-images
│   ├── custom-images
│   └── webportal-installer
├── custom_settings
│   ├── README.md
│   ├── VIMSWebPortal
│   ├── bishopmuseum
│   ├── cryoarks
│   ├── emoryherbarium
│   ├── fwrf
│   ├── fwri
│   ├── iz
│   ├── morpaleo
│   ├── newmexico
│   ├── os_webportal_mapping
│   ├── osichthyology
│   ├── sbmnhiz
│   ├── shellmuseum
│   ├── shellmuseum-1
│   ├── unsmvp
│   ├── uwfc
│   ├── webportalfish
│   └── wespalcoll
├── docker-compose.yml
├── git
│   └── webportal-installer
├── specify_exports
│   ├── PortalFiles
│   ├── README
│   ├── VIMSWebPortal.zip
│   ├── backup
│   ├── bishopmuseum.zip
│   ├── cryoarks.zip
│   ├── emoryherbarium.zip
│   ├── fwrf.zip
│   ├── fwri.zip
│   ├── iz.zip
│   ├── morpaleo.zip
│   ├── newmexico.zip
│   ├── os_webportal_mapping.zip
│   ├── osichthyology.zip
│   ├── sbmnhiz.zip
│   ├── shellmuseum.zip
│   ├── uwfc.zip
│   ├── webportalfish.zip
│   └── wespalcoll.zip
└── webportal-installer
    ├── AggregationDoc.txt
    ├── Dockerfile
    ├── LICENSE
    ├── Makefile
    ├── PortalApp
    ├── README.md
    ├── SearchingDoc.txt
    ├── build
    ├── custom_settings
    ├── get_latest_solr_vers.py
    ├── index_skel.html
    ├── make_fields_template.py
    ├── make_fldmodel_json.py
    ├── make_settings_template.py
    ├── make_solr_xml.py
    ├── make_toplevel_index.py
    ├── no_admin_web.xml
    ├── patch_schema_xml.py
    ├── patch_settings_json.py
    ├── patch_solrconfig_xml.py
    ├── patch_web_xml.py
    ├── solr-7.5.0
    ├── solr-7.5.0.tgz
    ├── specify_exports
    ├── webportal-nginx.conf
    ├── webportal-solr.service
    └── with_admin_web.xml
```

## Adding an Instance

Assuming the export made from Specify 6 is named `DataExport.zip` and it is in the current directory, you can use `scp` or `sftp` to copy the appropriate files to the web portal server. These were the steps I ran on my local machine to add the appropriate configuration files to the `webportal` SSH host:

```bash
scp ./DataExport.zip webportal:/home/ubuntu/specify_exports/sbmnhiz.zip
unzip DataExport.zip
cd PortalFiles
scp flds.json webportal:/home/ubuntu/custom_settings/sbmnhiz/fldmodel.json
cat PortalInstanceSetting.json
scp PortalInstanceSetting.json webportal:/home/ubuntu/custom_settings/sbmnhiz/settings.json
```

This creates the necessary templates for customizing the fields included in the portal and the custom settings.

## Loading New Data

Once your export has been added to `specify_exports` and all relevant custom settings have been added, you need to restart the `webportal` service for the changes to be applied.

1. Stop the `webportal` service in the `~/webportal-installer` directory

```bash
docker compose down
```

2. Start the `webportal` service again:

```bash
docker compose up -d
```

3. Once the solr service has started successfully (takes around 180 seconds after container starts), you can enter the container:

```bash
docker exec -it webportal /bin/bash
```

4. Once there, run `make load-data` to load data for all Web Portal instances:

```bash
make load-data
```

5. Once the data has loaded, exit the container, then verify the data is present on all 