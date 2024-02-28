## Image
create a one client pod with specify7, specify7-worker, webpack, nginx, and maybe specify6
excludes mariadb, redis, asset-server
```Dockerfile
FROM arm64v8/ubuntu:20.04

# Set environment variables
ENV DATABASE_HOST=localhost
ENV DATABASE_PORT=3306
ENV MASTER_NAME=master
ENV MASTER_PASSWORD=master
ENV SECRET_KEY=bogus
ENV ASSET_SERVER_URL=https://assets-test.specifycloud.org/web_asset_store.xml
ENV ASSET_SERVER_KEY=tnhercbrhtktanehul.dukb
ENV REPORT_RUNNER_HOST=report-runner
ENV REPORT_RUNNER_PORT=8080
ENV CELERY_BROKER_URL=redis://redis/0
ENV CELERY_RESULT_BACKEND=redis://redis/1
ENV LOG_LEVEL=WARNING
ENV SP7_DEBUG=true
ENV SP6_VERSION=6.8.03
ENV SP6_VERSION_STR=6803
# ENV SP6_VERSION_STR="${SP6_VERSION//.}"
# ENV SP6_VERSION_STR=$(echo "$SP6_VERSION" | tr -d '.')

#####################################################################

RUN apt-get update && \
 apt upgrade -y
RUN apt-get -y install --no-install-recommends \
 git \
 build-essential \
 libldap2-dev \
 libmariadbclient-dev \
 libsasl2-dev \
 nodejs \
 npm \
 python3-venv \
 python3.8 \
 python3.8-dev \
 redis \
 unzip \
 openjdk-8-jdk \
 maven \
 ant \
 awscli \
 mysql-client \
 nginx \
 certbot \
 python3-certbot-nginx;
RUN apt clean

#####################################################################

# Download repos
RUN wget https://update.specifysoftware.org/${SP6_VERSION_STR}/Specify_unix_64.sh
RUN git clone https://github.com/specify/specify7.git
RUN git clone https://github.com/specify/report-runner-service.git

#####################################################################

# Webpack
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash;
RUN export NVM_DIR="$HOME/.nvm";
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh";  # This loads nvm
RUN nvm install node;
RUN cd ~/specify7/specifyweb/frontend/js_src;
RUN npm ci;
RUN mkdir dist;
RUN npx webpack --mode production;

#####################################################################

# Specify7
RUN cd ~/specify7;
RUN make;

COPY specify7-django.service /etc/systemd/system/
COPY nginx.conf /home/ubuntu/specify7/nginx.conf

#####################################################################

# Report-runner-service
COPY report-fonts.jar /home/ubuntu/report-runner-service

RUN mkdir -p /tmp/build

COPY pom.xml /tmp/build

RUN cd ~/report-runner-service
RUN mvn compile && mvn war:exploded

COPY src /tmp/build/src
RUN mvn compile && mvn war:exploded

#####################################################################

# nginx webserver
RUN sed -i "s/server_name localhost/server_name sp7demofish/g" ~/specify7/nginx.conf;
RUN rm -f /etc/nginx/sites-available/default;
RUN sudo cp ~/specify7/nginx.conf /etc/nginx/sites-available/specify7;
RUN sudo ln -s /etc/nginx/sites-available/specify7 /etc/nginx/sites-enabled/;

#####################################################################

# Networking ports
EXPOSE 80 # nginx port
EXPOSE 8000 # django gunicorn port
EXPOSE 8080 # report runner port
# EXPOSE 3000 # Django Debug
# EXPOSE 8888 # Debugging service (ptvsd)

#####################################################################

COPY ./docker-entrypoint.sh ~/
CMD ["/bin/bash", "~/docker-entrypoint.sh"]

```

docker-entrypoint.sh
```bash
#!/bin/bash

# Set environment variables
export DOMAIN_NAME=$(hostname)
if ! [[ -v CLIENT_NAME ]]; then export CLIENT_NAME=sp7demofish; fi
if ! [[ -v DATABASE_NAME ]]; then export DATABASE_NAME=sp7demofish; fi
if ! [[ -v DATABASE_HOST ]]; then export DATABASE_HOST=localhost; fi
if ! [[ -v DATABASE_PORT ]]; then export DATABASE_PORT=3306; fi
if ! [[ -v MASTER_NAME ]]; then export MASTER_NAME=master; fi
if ! [[ -v MASTER_PASSWORD ]]; then export MASTER_PASSWORD=master; fi
if ! [[ -v SECRET_KEY ]]; then export SECRET_KEY=bogus; fi
if ! [[ -v ASSET_SERVER_URL ]]; then export ASSET_SERVER_URL=https://assets-test.specifycloud.org/web_asset_store.xml; fi
if ! [[ -v ASSET_SERVER_KEY ]]; then export ASSET_SERVER_KEY=tnhercbrhtktanehul.dukb; fi
if ! [[ -v REPORT_RUNNER_HOST ]]; then export REPORT_RUNNER_HOST=localhost; fi
if ! [[ -v REPORT_RUNNER_PORT ]]; then export REPORT_RUNNER_PORT=8080; fi
if ! [[ -v CELERY_BROKER_URL ]]; then export CELERY_BROKER_URL=redis://redis/0; fi
if ! [[ -v CELERY_RESULT_BACKEND ]]; then export CELERY_RESULT_BACKEND=redis://redis/1; fi
if ! [[ -v LOG_LEVEL ]]; then export LOG_LEVEL=WARNING; fi
if ! [[ -v SP7_DEBUG ]]; then export SP7_DEBUG=true; fi
if ! [[ -v SP6_VERSION ]]; then export SP6_VERSION=6.8.03; fi
if ! [[ -v SP6_VERSION_STR ]]; then export SP6_VERSION_STR="${SP6_VERSION//.}"; fi
if ! [[ -v WORKER_COUNT ]]; then export WORKER_COUNT=4; fi

echo 'export DOMAIN_NAME=$DOMAIN_NAME' >> ~/.bashrc;
echo 'export CLIENT_NAME=$CLIENT_NAME' >> ~/.bashrc;
echo 'export DATABASE_NAME=$DATABASE_NAME' >> ~/.bashrc;
echo 'export DATABASE_HOST=$DATABASE_HOST' >> ~/.bashrc;
echo 'export DATABASE_PORT=$DATABASE_PORT' >> ~/.bashrc;
echo 'export MASTER_NAME=$MASTER_NAME' >> ~/.bashrc;
echo 'export MASTER_PASSWORD=$MASTER_PASSWORD' >> ~/.bashrc;
echo 'export SECRET_KEY=$SECRET_KEY' >> ~/.bashrc;
echo 'export ASSET_SERVER_URL=$ASSET_SERVER_URL' >> ~/.bashrc;
echo 'export ASSET_SERVER_KEY=$ASSET_SERVER_KEY' >> ~/.bashrc;
echo 'export REPORT_RUNNER_HOST=$REPORT_RUNNER_HOST' >> ~/.bashrc;
echo 'export REPORT_RUNNER_PORT=$REPORT_RUNNER_PORT' >> ~/.bashrc;
echo 'export CELERY_BROKER_URL=$CELERY_BROKER_URL' >> ~/.bashrc;
echo 'export CELERY_RESULT_BACKEND=$CELERY_RESULT_BACKEND' >> ~/.bashrc;
echo 'export LOG_LEVEL=$LOG_LEVEL' >> ~/.bashrc;
echo 'export SP7_DEBUG=$SP7_DEBUG' >> ~/.bashrc;
echo 'export SP6_VERSION=$SP6_VERSION' >> ~/.bashrc;
echo 'export SP6_VERSION_STR=$SP6_VERSION_STR' >> ~/.bashrc;
echo 'export WORKER_COUNT=$WORKER_COUNT' >> ~/.bashrc;

# Specify7 Django
cp specifyweb.wsgi specifyweb_wsgi.py;
sudo systemctl enable specify7-django.service;
sudo systemctl start specify7-django.service;

# Specify7 worker
cd ~/specify7;
celery -A specifyweb worker -l INFO --concurrency=1 &;

# Report runner


# nginx webserver
sudo systemctl daemon-reload;
sudo systemctl restart nginx;

```

specify7-django.service
```service
[Unit]
Description=Specify 7 Django Server
Wants=network.target

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/specify7
ExecStart=/home/ubuntu/specify7/ve/bin/gunicorn -w 3 -b 0.0.0.0:8000 -t 300 specifyweb_wsgi
Restart=always

[Install]
WantedBy=multi-user.target
```

report-runner.service
```service
[Unit]
Description=Specify Report Runner Service
Wants=network.target
ConditionPathExists=/home/ubuntu/report-runner-service

[Service]
User=ubuntu
WorkingDirectory=/home/ubuntu/report-runner-service
ExecStart=/usr/bin/mvn jetty:run

[Install]
Alias=ireportrunner.service
```