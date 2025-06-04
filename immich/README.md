# Immich 

Service for managing videos and photos. Google photos like.

In order to properly connect to the postgres database first you need to run:
- `docker exec -it immich_postgres psql -U postgres`
- `ALTER USER postgres WITH PASSWORD 'postgres';`