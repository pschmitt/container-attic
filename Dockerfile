FROM nixos/nix:latest

RUN echo "experimental-features = flakes nix-command" >> /etc/nix/nix.conf && \
    nix profile install 'github:zhaofengli/attic#attic'

COPY ./server.example.toml /config/server.toml
COPY ./entrypoint.sh /entrypoint.sh

ENV ATTIC_CONFIG_FILE=/config/server.toml \
    ATTIC_SERVER_TOKEN_HS256_SECRET_BASE64=

VOLUME ["/config", "/data"]

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8080
