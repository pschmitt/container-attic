FROM nixos/nix:latest

RUN echo "experimental-features = flakes nix-command" >> /etc/nix/nix.conf

RUN nix profile install 'github:zhaofengli/attic#attic'

ENTRYPOINT ["/root/.nix-profile/bin/attic"]
