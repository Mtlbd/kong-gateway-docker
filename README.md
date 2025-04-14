# Kong API Gateway + Konga Setup with Docker

This document explains how to set up Kong API Gateway along with the Konga UI using Docker.

---

## 🧠 Prerequisites

- Docker and Docker Compose installed
- Basic familiarity with containers and Docker networking

---

## 🕸️ Create Docker Network

First, create a dedicated network for the containers to communicate:

```bash
docker network create kong-net
```

---

## 🐘 Run Postgres Database

Kong needs a database to store its configurations. Here we use PostgreSQL:

```bash
docker run -d --name kong-database \
  --network=kong-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:11
```

---

## 🧱 Initialize Kong Database (Migrations)

Prepare the database with the required Kong schema:

```bash
docker run --rm \
  --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_PASSWORD=kong" \
  kong/kong-gateway:3.10.0.0 kong migrations bootstrap
```

---

## 🚪 Run Kong Gateway

Now run the main Kong Gateway container:

```bash
docker run -d --name kong-gateway \
  --network=kong-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-database" \
  -e "KONG_PG_USER=kong" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PROXY_ACCESS_LOG=/dev/stdout" \
  -e "KONG_ADMIN_ACCESS_LOG=/dev/stdout" \
  -e "KONG_PROXY_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_ERROR_LOG=/dev/stderr" \
  -e "KONG_ADMIN_LISTEN=0.0.0.0:8001" \
  -e "KONG_ADMIN_GUI_URL=http://localhost:8002" \
  -e KONG_LICENSE_DATA \
  -p 8000:8000 \
  -p 8443:8443 \
  -p 8001:8001 \
  -p 8444:8444 \
  -p 8002:8002 \
  -p 8445:8445 \
  -p 8003:8003 \
  -p 8004:8004 \
  kong/kong-gateway:3.10.0.0
```

---

## 📊 Run Konga Admin UI

Konga is a simple and elegant UI to manage Kong:

```bash
docker run -d --name konga \
  --network=kong-net \
  -p 1337:1337 \
  -e "DB_ADAPTER=postgres" \
  -e "DB_HOST=kong-database" \
  -e "DB_PORT=5432" \
  -e "DB_USER=kong" \
  -e "DB_PASSWORD=kong" \
  -e "DB_DATABASE=kong" \
  pantsel/konga
```

---

## 📍 Access URLs

- **Konga UI:** [http://localhost:1337](http://localhost:1337)
- **Kong Admin API:** [http://localhost:8001](http://localhost:8001)

---

## ✅ Notes

- Use stronger and secure passwords for production environments.
- To use Kong Enterprise, set the `KONG_LICENSE_DATA` environment variable.
- Consider using Docker Compose for better management.


---

## 🚀 Run All Services with Docker Compose

- Alternatively, you can use Docker Compose to start all services (Postgres, Kong Gateway, and Konga) with a single command.
- Make sure you have docker-compose.yml in your project directory.

Run the following command:

```bash
docker-compose up -d
```

- This will start all the containers in detached mode.

---

The End 🎉

