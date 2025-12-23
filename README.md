# Home server

A collection of services exclusively run in docker containers.

Helper script `start_services.sh` for creating, starting/stopping containers.

Clone the repository:
```
git clone --recursive https://github.com/georgemarian98/home-server.git
```

Don't forget to set the variables in .env file(s).

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