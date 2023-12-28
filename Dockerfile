FROM nixos/nix:latest

# NOTE filter-syscalls=false fixes builds on arm64
# https://github.com/NixOS/nix/issues/5258
RUN echo "experimental-features = flakes nix-command" >> /etc/nix/nix.conf && \
    echo "filter-syscalls = false" >> /etc/nix/nix.conf && \
    nix profile install 'github:zhaofengli/attic#attic'

ENTRYPOINT ["/root/.nix-profile/bin/attic"]
