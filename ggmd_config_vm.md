# Configuration VM pour GGMD

## Sur OpenStack
- Ouverture en TCP du port 5432
- Création ggmd_01 (flavour m1.small)
- Création ggmd_02 (flavour m1.medium)
- Création ggmd_03 (flavour m1.large)
- Créer un volume de stockage des données

## MAJ Système 

sudo apt update
sudo apt upgrade

sudo apt install inxi    //Pour les informations systèmes15:00


## montage du volume
 
sudo mkdir /data 
sudo mkfs.ext4 /dev/vdb
sudo mount -a /dev/vdb/ /data/
sudo chown ubuntu:ubuntu /data


## Configuration du serveur ggmd-prof

sudo apt install postgresql postgresql-contrib
sudo -i -u postgres
psql 
create database insee;
create user ens with password 'piscinemardi';
GRANT ALL PRIVILEGES ON DATABASE insee to ens;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO etum2;

psql -h localhost ens -d insee
psql -h localhost etum2 -d insee


## transfert des données

cd /data/Enseignements/M2_GGMD/
scp -i /data/deptCloud/cles/pedabdcloud ./ggmd_tp1_data.gz ubuntu@192.168.246.201:/data/

gunzip -c ggmd_tp1_data.gz | psql -h localhost ens -d insee

psql -h localhost ens -d insee

\dt


## Installation CITUS + Postgresql 14


### sur tous les noeuds

curl https://install.citusdata.com/community/deb.sh | sudo bash

sudo apt-get -y install postgresql-14-citus-10.2

sudo pg_conftool 14 main set shared_preload_libraries citus

sudo pg_conftool 14 main set listen_addresses '*'

sudo nano /etc/postgresql/14/main/pg_hba.conf
 scram-sha-256   => trust
 127.0.0.0/32   =>  192.168.77.0/8
sudo service postgresql restart

Modifier /etc/postgresql/14/main/postgresql.conf en sudo
data_directory = '/insee/postgresql_dir' 

A faire par les étudiants

sudo -i -u postgres psql -c "CREATE EXTENSION citus;"

### sur le coordinateur

sudo -i -u postgres psql -c \
  "SELECT citus_set_coordinator_host('192.168.77.106', 5432);"
https://forge.univ-lyon1.fr/dashboard/groups
sudo -i -u postgres psql -c "SELECT * from citus_add_node('192.168.77.58', 5432);"
sudo -i -u postgres psql -c "SELECT * from citus_add_node('192.168.77.8', 5432);"



## Installation Postgresql 12


sudo apt install postgresql postgresql-contrib
sudo -i -u postgres
psql 
create database insee;
create user etum2 with password 'etum2';
GRANT ALL PRIVILEGES ON DATABASE insee to etum2;

psql -h localhost etum2 -d insee


Au niveau Openstack, ouverture en TCP du port 5432

sudo nano /etc/postgresql/12/main/postgresql.conf 
port = 5433
listen_addresses = 'localhost'   =>  listen_addresses = '*' 

Modifier /etc/postgresql/12/main/pg_hba.conf en sudo
ligne # IPv4 local connections:
host     all      all    127.0.0.1/32    md5   => host     all      all    0.0.0.0/0   md5


sudo service postgresql restart





