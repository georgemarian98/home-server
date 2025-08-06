# Home server

A collection of services exclusively run in docker containers.

In order to start all the services use the `start_services.sh` script.

Clone the repository:
```
git clone --recursive https://github.com/georgemarian98/home-server.git
```

Don't forget to set the variables in .env file.

# Media server
The folder structure for entertainment media. This structure is used by Jellyfin, QBittorrent, prowlarr, radarr, etc.
```
Entertainment
│── qbittorrent
│   ├── completed
│   ├── incomplete
│── media
    ├── movies
    ├── shows
```

# TODO:
- [ ] Automated media management (jellyseerr/overseer, lidarr, huntarr etc)
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

# Hardware:
- [ ] [Aoostart GEM10](https://aoostar.com/products/aoostar-gem10-amd-ryzen-7-7840hs-mini-pc-with-win-11-pro-3-nvme-oculink-2-2-5g-lan?variant=47708556755242)
- [ ] [HDD enclousures with oculink support](https://www.servercase.co.uk/shop/components/hot-swap-drive-enclosures/in-win-iw-sk35-07---5x-35-nvmesassata-hdd-in-3x-525-bay-hot-swap-module---oculink-connection-iw-sk35-07/)
- [ ] 3 HDDs 10TB
