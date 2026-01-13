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

# Script
Script will help you start/stop the containers. This will work with docker compose files and with swarm as well.
In the root directory there is an .env file that has basic variables that are needed for many services.
Each service has its dedicated folder with the following files:
- A docker compose file named `docker-compose.yaml` (required)
- A docker compose file for swarm mode named `docker-compose-swarm.yaml` (optional)
- An .env file for nedded environment variables for the container (optional)
- An .env.compose file needed to parameterized the docker compose files (optional)
- A README file for additional information

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