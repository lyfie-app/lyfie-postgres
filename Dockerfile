FROM pgvector/pgvector:pg16

# This ARG is special: it's automatically filled by Docker buildx
ARG TARGETARCH
ARG PGVECTORS_TAG=0.2.1

RUN apt-get update && apt-get install -y wget && \
    # Map Docker arch names to GitHub release names
    if [ "$TARGETARCH" = "amd64" ]; then ARCH="x86_64"; \
    elif [ "$TARGETARCH" = "arm64" ]; then ARCH="aarch64"; \
    else ARCH=$TARGETARCH; fi && \
    # Construct the download URL using the mapped ARCH
    wget -nv -O /tmp/pgvectors.deb "https://github.com/tensorchord/pgvecto.rs/releases/download/v${PGVECTORS_TAG}/vectors-pg16_${ARCH}-unknown-linux-gnu_${PGVECTORS_TAG}.deb" && \
    apt-get install -y /tmp/pgvectors.deb && \
    # Cleanup
    rm -f /tmp/pgvectors.deb && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN echo "shared_preload_libraries = 'vectors.so'" >> /usr/share/postgresql/postgresql.conf.sample

CMD ["postgres"]
