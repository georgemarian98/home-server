# Qbittorrent

For downloading torrents. 
On the first login, you must look into the container logs to find the generated password and after that you must change it.

The .env file needs to contain the following variables:
```
PUID=${USER_ID}
PGID=${GROUP_ID}
TZ=${TIMEZONE}
WEBUI_PORT=PORT
```

and the .env.compose file:
```
# Directory for qBittorrent to download files. Later picked up by the media server.
DOWNLOAD_DIR=PATH
```