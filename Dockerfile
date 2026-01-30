FROM pgvector/pgvector:pg16

ARG TARGETARCH
ARG PGVECTORS_TAG=0.2.1

RUN apt-get update && apt-get install -y wget && \
    # For v0.2.1, the .deb uses amd64/arm64 directly in the filename
    wget -nv -O /tmp/pgvectors.deb "https://github.com/tensorchord/pgvecto.rs/releases/download/v${PGVECTORS_TAG}/vectors-pg16_${PGVECTORS_TAG}_${TARGETARCH}.deb" && \
    apt-get install -y /tmp/pgvectors.deb && \
    rm -f /tmp/pgvectors.deb && \
    apt-get remove -y wget && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

RUN echo "shared_preload_libraries = 'vectors.so'" >> /usr/share/postgresql/postgresql.conf.sample

CMD ["postgres"]
