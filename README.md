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
- [ ] Extend the start script to be able to handle multiple services
- [ ] In the movie backlog app, make sure that the current user is shown correctly in the select list
- [ ] Reseach another image repository that stores images in more of a manageable manner (Immich will store each image in a different folder, based on the hash and I don't like that, it make it harder to look at them outside of immich)
- [ ] password manager - if it's good (bitwarden, vaultwarden)
- [ ] Filebrowser (nextcloud, filecloud, opencloud)
- [ ] Steam cache - maybe if it's playable offline and upgrade server size
- [ ] Monitoring resources (netdata, grafana, prometheus)
- [ ] Watchtower
- [ ] Unattended updates
- [ ] SECURITY, FIREWALL
- [ ] Remote access - vpn, twingate/tailscale?, cloudfare, pangolin - more research
- [ ] Backup to another server (syncthing?)
- [ ] KVM?

# Research
- [ ] LXC proxmox containers, VMs vs Containers strategy
- [ ] Proxmox
- [ ] Truenas in Proxmox
- [ ] ZFS
- [ ] Wake on LAN

# Hardware:
- [ ] [Aoostart GEM12](https://aoostar.com/products/aoostar-gem12-amd-ryzen-9-6900hx-mini-pc-with-16-32g-ddr5-ram-512g-1t-pcle-4-0-ssd-win-11-pro-2-nvme-oculink-2-2-5g-lan-non-screened-version?srsltid=AfmBOoqbtIPhEyy-Pif7RFulR1Xfnz5KNT1_f9Z3VNtgcfXN8BDI5Cjy)
- [ ] [HDD enclousures with oculink support](https://www.servercase.co.uk/shop/components/hot-swap-drive-enclosures/in-win-iw-sk35-07---5x-35-nvmesassata-hdd-in-3x-525-bay-hot-swap-module---oculink-connection-iw-sk35-07/)
or
- [ ] [AOOSTAR WTR PRO AMD Ryzen 7 5825u 4 Bay Nas Mini PC](https://aoostar.com/products/aoostar-wtr-pro-4-bay-90t-storage-amd-ryzen-7-5825u-nas-mini-pc-support-2-5-3-5-hdd-%E5%A4%8D%E5%88%B6?variant=49223255195946)
or
- [ ] [Minisforum N5 Desktop NAS](https://minisforumpc.eu/products/minisforum-n5-desktop-nas)
or
- [ ] [Zima Cube](https://www.zimaspace.com/products/cube-personal-cloud#specs) - idk pretty pricey

- [ ] 3 HDDs 10TB

