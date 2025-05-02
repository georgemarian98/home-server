# Home server

A collection of services exclusively run in docker containers.

In order to start all the services use the `start_services.sh` script.

Clone the repository:
```
git clone --recursive https://github.com/georgemarian98/home-server.git
```

# TODO:
- [ ] Make sure that the `start_services.sh` script works when creating all the containers
- [ ] Use encryption for all services (HTTPS)
- [ ] Python script for CLI hardware stats
- [ ] password manager - if it's good (bitwarden, vaultwarden)
- [ ] Google Photo replacement (Immich, photoprism, nextcloud, filecloud, opencloud)
- [ ] Filebrowser
- [ ] Torrent (jellyseerr, sonarr, radaar, overseer, lidarr, transmission, etc)
- [ ] In the movie backlog app, make sure that the current user is shown correctly in the select list
- [ ] Steam cache - maybe if it's playable offline and upgrade server size
- [ ] Monitoring resources (netdata)
- [ ] Watchtower
- [ ] Unattended updates
- [ ] SECURITY, FIREWALL
- [ ] Remote access - vpn, twingate/tailscale?, cloudfare, pangolin - more research
