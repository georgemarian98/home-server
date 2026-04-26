# Paperless

[Documentation](https://docs.paperless-ngx.com/)

Document management system.
In order to start the docker container an .env file and an .env,compose file is needed.
For the .env file you can start with example.env file, The majority of desired variables are there.
The .env.compose file should contain the following:
```
PAPERLESS_DIR=<PATH_TO_DIR>
SERVER_DIR=${PAPERLESS_DIR}/server
REDIS_DIR=${PAPERLESS_DIR}/redis
POSTGRES_DIR=${PAPERLESS_DIR}/postgres

# Postgress
POSTGRES_DB=<DB>
POSTGRES_USER=<USER>
POSTGRES_PASSWORD=<PASSWORD>
```