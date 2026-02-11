# Immich 

Service for managing videos and photos. Google photos like.

In order to properly connect to the postgres database first you need to run:
- `docker exec -it immich_postgres psql -U postgres`
- `ALTER USER postgres WITH PASSWORD 'postgres';`

For the .env file visit [immich docs](https://docs.immich.app/install/docker-compose/)