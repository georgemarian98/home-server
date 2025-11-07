# Home server

A collection of services exclusively run in docker containers.

In order to start all the services use the `start_services.sh` script.

Clone the repository:
```
git clone --recursive https://github.com/georgemarian98/home-server.git
```

Don't forget to set the variables in .env file.

**Important**
Containers will not expose any ports. All the external trafic will be handled thorough the proxy manager.

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
- [x] Portforward from router to pihole 
- [x] Pi-hole DNS server 
- [x] Update READMEs 
- [x] Make sure that the start_services.sh script works when creating all the containers
- [x] generate ssh key for log ing
- [x] Update READMEs
- [x] Make sure that the `start_services.sh` script works when creating all the containers
- [x] Python script for CLI hardware stats
- [x] Google Photo replacement (Immich, photoprism)
- [x] Use encryption for all services (HTTPS)
- [x] Bash script: allow each service to have a env file ( if possible)
- [x] Automated media management (jellyseerr/overseer, lidarr, huntarr etc)
- [x] Polish docker compose files, volumes, network, etc and moviebacklog and immich both use postgres, maybe we can use the same container
- [x] Investigate the posibility to avoid exposing the container's port while being on the same network as the proxy manager and only exposing it via the proxy manager
- [x] Extend the start script to be able to handle multiple services
- [x] In the movie backlog app, make sure that the current user is shown correctly in the select list
- [x] In the movie backlog app, when a media image is no longer available, update it.
- [x] In the movie backlog app, fix workflow.
- [x] In the movie backlog app, solve invalid API key error. Only replicable on docker linux
- [ ] In the movie backlog app, use environment variables in appsettings.json.
- [ ] Script to initialize a new machine with all my preferences and apps
- [x] Reseach another image repository that stores images in more of a manageable manner (Immich will store each image in a different folder, based on the hash and I don't like that, it make it harder to look at them outside of immich)
- [ ] password manager - if it's good (bitwarden, vaultwarden)
- [ ] Filebrowser (nextcloud, filecloud, opencloud)
- [ ] Glance dashboard
- [ ] vert, zrok ? idk
- [ ] Steam cache - maybe if it's playable offline and upgrade server size
- [ ] Monitoring resources (netdata, grafana, prometheus)
- [ ] Watchtower
- [ ] Unattended updates
- [ ] SECURITY, FIREWALL
- [ ] Remote access - vpn, twingate/tailscale?, cloudfare, pangolin - more research
- [ ] Backup to another server (syncthing?)
- [ ] KVM?

# Research
- [x] LXC proxmox containers, VMs vs Containers strategy
- [ ] Proxmox
- [x] Truenas in Proxmox
- [ ] ZFS
- [ ] Wake on LAN