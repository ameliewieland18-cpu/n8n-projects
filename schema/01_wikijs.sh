#!/bin/bash

wiki_db_name="${WIKIJS_DB_NAME:-wiki}"

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set=wiki_db_name="$wiki_db_name" <<'EOSQL'
SELECT format('CREATE DATABASE %I OWNER %I', :'wiki_db_name', current_user)
WHERE NOT EXISTS (
  SELECT 1
  FROM pg_database
  WHERE datname = :'wiki_db_name'
)\gexec
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$wiki_db_name" <<'EOSQL'
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
EOSQL
