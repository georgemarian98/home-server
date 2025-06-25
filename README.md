# Home server

A collection of services exclusively run in docker containers.

In order to start all the services use the `start_services.sh` script.

Clone the repository:
```
git clone --recursive https://github.com/georgemarian98/home-server.git
```

Don't forget to set the variables in .env file.

# TODO:
- [ ] Torrent (jellyseerr, sonarr, radaar, overseer, lidarr, transmission, etc)
- [ ] In the movie backlog app, make sure that the current user is shown correctly in the select list
- [ ] Polish docker compose files, volumes, network, etc and moviebacklog and immich both use postgres, maybe we can use the same container
- [ ] password manager - if it's good (bitwarden, vaultwarden)
- [ ] Filebrowser
- [ ] Steam cache - maybe if it's playable offline and upgrade server size
- [ ] Monitoring resources (netdata, grafana, prometheus)
- [ ] Watchtower
- [ ] Unattended updates
- [ ] SECURITY, FIREWALL
- [ ] Remote access - vpn, twingate/tailscale?, cloudfare, pangolin - more research
- [ ] Backup to another server (syncthing?)
