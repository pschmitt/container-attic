#!/usr/bin/env bash

ATTIC_CONFIG_FILE="${ATTIC_CONFIG_FILE:-/config/server.toml}"
ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="${ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64:-}"

database_url() {
  sed -nr 's#^url *= *"?([^"]+)"?#\1#p' "$ATTIC_CONFIG_FILE"
}

database_type() {
  local db_url
  db_url="$(database_url)"
  echo "${db_url//:*}"
}

database_path() {
  local db_url
  db_url="$(database_url)"
  echo "${db_url##*://}"
}

database_init() {
  if [[ $(database_type) != "sqlite" ]]
  then
    echo "Database type is not SQLite, skipping initialization" >&2
    return 0
  fi

  local db_path
  db_path="$(database_path)"
  if [[ ! -f "$db_path" ]]
  then
    echo "Creating SQLite database at $db_path"
    touch "$db_path"
  fi
}

if [[ -z "$ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64" ]]
then
  {
    echo "ERROR: ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64 is not set"
    echo "Generate with: \$ openssl rand 64 | base64 -w0"
  } >&2
  exit 2
fi

database_init

exec atticd --config "$ATTIC_CONFIG_FILE" "$@"
