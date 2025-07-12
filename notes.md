# Getting the data

```sh
git clone https://forge.univ-lyon1.fr/javier.espinosa2/ggmd-tp1-data.git
mv ggmd-tp1-data/  data/
gunzip -c data/ggmd_tp1_data.gz > data/ggmd_tp1_data
```


# Testing locally

```
docker run --rm -it --name postgres \
    -e POSTGRES_USER=postgres \
    -e POSTGRES_PASSWORD=postgres \
    -e PGDATA=/data \
    -v /Users/j/Desktop/ggmd-insee/data/ggmd_tp1_data:/ggmd_tp1_data.sql \
    -v /Users/j/Desktop/ggmd-insee/init-insee-db.sh:/docker-entrypoint-initdb.d/init-insee-db.sh \
    postgres:17.5

docker stop postgres && docker rm postgres
```



# Building the GGMD INSEE image

```
docker build --no-cache -t ggmd .

docker build -t ggmd-citus -f Dockerfile-citus .

```

# Send image to Docker Hub

```
docker tag ggmd jaeo/ggmd
docker push jaeo/ggmd
```


# Trying the image

```
docker run -d --name postgres ggmd      # docker run -d --name postgres jaeo/ggmd

# docker run -d --name postgres ggmd-citus 

docker exec -it postgres psql -U postgres 

docker exec -it postgres psql -U postgres -c "SELECT * FROM citus_version();"


\c insee
\dt

docker stop postgres && docker rm postgres

```
