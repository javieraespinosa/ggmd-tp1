#!/usr/bin/env bash
set -e

TP_DB="insee"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    create database "$TP_DB";
    create user ens with password 'piscinemardi';
    create user etum2 with password 'etum2';
    GRANT ALL PRIVILEGES ON DATABASE "$TP_DB" to ens;
EOSQL


psql -v ON_ERROR_STOP=0 -d "$TP_DB" -f /ggmd_tp1_data.sql
