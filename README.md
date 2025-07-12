# GGMD TP1 

Two Docker images are available:

* **Postgres 17** with the INSEE database
* **Citus 16** (single-node cluster with Postgres 16) with the INSEE database


# Try it! 

## Get the repo

> Unnecessary if using GitHub Codespaces

```sh
git clone https://github.com/javieraespinosa/ggmd-tp1.git
```

## Start database servers

```docker
docker compose up
```

## Connect to server and query

Execute in a **new terminal**:

```sh
docker exec -it pgdb psql -U postgres 
```

* Query

```sql
\c insee
\dt
SELECT * FROM region LIMIT 10;
```


# Stop containers & remove volumes

```docker
docker compose down -v
```
