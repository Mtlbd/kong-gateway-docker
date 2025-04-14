# Use a multi-stage build approach to install dependencies and setup the environment

# Stage 1: Build the Postgres container
FROM postgres:11 as postgres

# Stage 2: Build the Kong container
FROM kong/kong-gateway:3.10.0.0 as kong-gateway

# Stage 3: Build the Konga container
FROM pantsel/konga as konga

# Expose necessary ports for each container
EXPOSE 8000 8443 8001 8444 8002 8445 8003 8004
EXPOSE 1337 5432

# Environment variables for Kong and Konga
ENV KONG_DATABASE=postgres
ENV KONG_PG_HOST=kong-database
ENV KONG_PG_USER=kong
ENV KONG_PG_PASSWORD=kong
ENV DB_ADAPTER=postgres
ENV DB_HOST=kong-database
ENV DB_PORT=5432
ENV DB_USER=kong
ENV DB_PASSWORD=kong
ENV DB_DATABASE=kong

# Run the services in parallel with Docker Compose
CMD ["docker-compose", "up", "-d"]
