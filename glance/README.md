# Glance

Dashboard page. Super lightweight.

https://github.com/glanceapp/glance/blob/main/docs/configuration.md#configuring-glance

https://github.com/glanceapp/community-widgets

The .env file needs to contain the following variables:
```
# Variables defined here will be available to use anywhere in the config with the syntax ${MY_SECRET_TOKEN}
# Note: making changes to this file requires re-running docker compose up
PIHOLE_PASS=<PIHOLE_PASSWORD>
PIHOLE_ADDRESS=<PIHOLE_ADDRESS> # ip or domain name of the pihole server
```