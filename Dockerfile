FROM nixos/nix:latest

RUN echo "experimental-features = flakes nix-command" >> /etc/nix/nix.conf && \
    nix profile install 'github:zhaofengli/attic#attic'

COPY ./server.example.toml /config/server.toml

VOLUME ["/config", "/data"]

ENTRYPOINT ["/root/.nix-profile/bin/atticd", "--config", "/config/server.toml"]

EXPOSE 8080
