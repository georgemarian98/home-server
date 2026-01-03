# Traefik

First you must own a domain. I bought mine on cyberFolks.ro and registered it on Cloudflare. I had to modify the nameservers to point to Cloudflare.
Second in Cloudflare I added 2 records: 
- A record for the domain name to point to my linux server
- CNAME record with * name to redirect all subdomains to the server automatically.


After that you need the API token from Cloudflare and put it in .env file for CF_DNS_API_TOKEN variable.
In the end you can start reverse proxy your services with the following labels to each service:
```
- "traefik.http.routers.obsidian.rule=Host(`<SUBDOMAIN>.<DOMAIN>`)"
- "traefik.http.routers.obsidian.entrypoints=websecure"
- "traefik.http.routers.obsidian.tls.certresolver=cloudflare"
- "traefik.http.services.obsidian.loadbalancer.server.port=<EXPOSED_PORT>"
```