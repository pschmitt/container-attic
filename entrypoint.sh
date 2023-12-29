#!/sbin/env sh

ATTIC_CONFIG_FILE="${ATTIC_CONFIG_FILE:-/config/server.toml}"
ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64="${ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64:-}"

database_url() {
  sed -nr 's#^url *= *"?([^"]+)"?#\1#p' "$ATTIC_CONFIG_FILE" | \
    tr -d '\r'
}

database_type() {
  database_url | sed -nr 's#([^:]+)://.*#\1#p'
}

database_path() {
  database_url | sed -nr 's#.*://(.*)#\1#p'
}

database_init() {
  if [ "$(database_type)" != "sqlite" ]
  then
    echo "Database type is not SQLite, skipping initialization" >&2
    return 0
  fi

  db_path="$(database_path)"
  if ! [ -f "$db_path" ]
  then
    echo "Creating SQLite database at $db_path"
    mkdir -p "$(dirname "$db_path")"
    touch "$db_path"
  fi

  unset db_path
}

if [ -z "$ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64" ] || \
   [ "$ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64" = "changeme" ]
then
  {
    echo "ERROR: ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64 is not set"
    echo "Generate with: \$ openssl rand 64 | base64 -w0"
  } >&2
  exit 2
fi

database_init

exec atticd --config "$ATTIC_CONFIG_FILE" "$@"
