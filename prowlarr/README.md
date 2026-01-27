# Prowlarr

Indexer that integrates with radarr, sonarr, etc. in order to have a common list of indexes and download clients.

Usefull guides:
- [Servarr Wiki](https://wiki.servarr.com/radarr/quick-start-guide)
- [TRaSH Guide](https://trash-guides.info/)

The .env file needs to contain the following variables:
```
PUID=${USER_ID}
PGID=${GROUP_ID}
TZ=${TIMEZONE}
UMASK=002
```