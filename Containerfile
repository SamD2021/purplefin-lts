# Allow build scripts to be referenced without being copied into the final image
FROM scratch AS ctx
COPY build_files /

# Main bootc image
FROM ghcr.io/ublue-os/bluefin:lts


# Make /usr/local writable by overlay
RUN mkdir -p /usr/local/bin && \
    systemctl enable ostree-state-overlay@usr-local-bin.service

# Create /nix mountpoint
RUN rm -rf /nix && mkdir -p /nix 

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build.sh && \
    ostree container commit

ENV PATH="${PATH}:/nix/var/nix/profiles/default/bin"

RUN bootc container lint

