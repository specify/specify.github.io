# VS Code Django Unit Test Debugging

Might need to add permissions to the test db for the master user:
`mysql --host 127.0.0.1 -u root -p'root' -e "GRANT ALL PRIVILEGES ON test_cuic.* TO 'master'@'%';"`
`GRANT ALL PRIVILEGES ON test_.* TO 'master'@'%';`

https://devpress.csdn.net/python/62fe07607e66823466192fa3.html

```sh
ve/bin/pip install pytest pytest-django
```

```sh
ve/bin/pip install hypothesis==6.4.0 hypothesis-jsonschema==0.19.0
```

specifyweb/pytest.ini ->
```sh
[pytest]
DJANGO_SETTINGS_MODULE=specifyweb.settings
python_files=*test*.py testparsing.py
addopts = --ignore=specifyweb/specify/selenium_tests.py
```

.vscode/settings.json ->
```sh
{
    "python.pythonPath": "ve/bin/python",
    "python.testing.pytestArgs": [
        "specifyweb",
        "-s",
        "-vv"
    ],
    "python.testing.pytestEnabled": true,
    "python.testing.nosetestsEnabled": false,
    "python.testing.unittestEnabled": false
}
```

.env -> not needed
```sh
PYTHONPATH=specifyweb/
```

manage.py ->
paste between "os.environ.setdefault" ... "try: from django.core.management"
```python
from django.conf import settings

    if settings.DEBUG:
        if os.environ.get('RUN_MAIN') or os.environ.get('WERKZEUG_RUN_MAIN'):
            import debugpy
            debugpy.listen(("0.0.0.0", 3000))
            print('Attached!')
```

requirement-testing.txt ->
```text
debugpy==1.6.5
pytest==7.2.1
pytest-django==4.5.2
```

docker-compose.yml ->
```yaml
ports:
  - 3000:3000 # Django Debug
  - 8888:8888 # debugging service (ptvsd)

SECRET_KEY=bogus
```

Dockerfile ->
```Dockerfile
COPY --chown=specify:specify requirements-testing.txt /home/specify/

RUN python3.8 -m venv ve \
 && ve/bin/pip install --no-cache-dir -r /home/specify/requirements-testing.txt \
 && ve/bin/pip install --no-cache-dir -r /home/specify/requirements.txt
```

For the non-container instance of vscode, the debugger is used at runtime with the front-end:

.vscode/launch.json ->
```json
{
    "version": "0.2.0",
    "configurations": [
      {
        "name": "Run Django",
        "type": "python",
        "request": "attach",
        "pathMappings": [
          {
            "localRoot": "${workspaceFolder}/specifyweb",
            "remoteRoot": "/opt/specify7/specifyweb"
          }
        ],
        "port": 3000,
        "host": "127.0.0.1",
      }
    ]
  }
```

.vscode/settings.json ->
```json
{
    "python.testing.unittestArgs": [
        "-v",
        "-s",
        "./specifyweb",
        "-p",
        "*test*.py"
    ],
    "python.testing.pytestEnabled": false,
    "python.testing.unittestEnabled": true,
    "python.linting.mypyEnabled": true,
    "python.linting.enabled": true
}
```

### Get the VS Code debugger to work with the celery container

Add the worker debugger config to the .vscode/launch.json file
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Run Django",
      "type": "python",
      "request": "attach",
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}/specifyweb",
          "remoteRoot": "/opt/specify7/specifyweb"
        }
      ],
      "port": 3000,
      "host": "127.0.0.1",
    },
    {
      "name": "Run Worker",
      "type": "python",
      "request": "attach",
      "pathMappings": [
        {
          "localRoot": "${workspaceFolder}/specifyweb",
          "remoteRoot": "/opt/specify7/specifyweb"
        }
      ],
      "port": 3001,
      "host": "127.0.0.1",
    }
  ]
}
```

Edit the command in the celery worker container config in the docker-compose.yml file
```yaml
  specify7-worker:
    build:
      context: ./.
      target: run-development
    command: bash -c "ve/bin/python -m debugpy --listen 0.0.0.0:3001 --wait-for-client -m celery -A specifyweb worker -l INFO --concurrency=1 -Q $DATABASE_NAME"
    init: true
    volumes:
      - "./config:/opt/Specify/config:ro"
      - "static-files:/volumes/static-files"
      - "./specifyweb:/opt/specify7/specifyweb"
    extra_hosts:
      - "host.docker.internal:host-gateway"
    env_file: .env
```

Run `docker compose up --build`

Reload the vscode window

In the VS Code debugger panel, next to "Run and Debug", select the picklist and select "Run Worker", and press the play button.

The breakpoints you set should now be caught!

