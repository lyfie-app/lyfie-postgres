FROM bitnami/postgresql-repmgr:16

# 1. Switch to root for installation
USER root

# 2. Define versions (matches your first script's logic)
ARG PG_MAJOR=16
ARG VECTORCHORD_TAG=v0.1.3
ARG PGVECTORS_TAG=0.2.1
ARG TARGETARCH=amd64

# 3. Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# 4. Install pgvecto.rs (using your working zip method)
RUN wget https://github.com/tensorchord/pgvecto.rs/releases/download/v${PGVECTORS_TAG}/vectors-pg${PG_MAJOR}_x86_64-unknown-linux-gnu_${PGVECTORS_TAG}.zip -O /tmp/vectors.zip \
    && unzip /tmp/vectors.zip -d /tmp/vectors \
    && cp /tmp/vectors/vectors.so /opt/bitnami/postgresql/lib/ \
    && cp /tmp/vectors/vectors--* /opt/bitnami/postgresql/share/extension/ \
    && cp /tmp/vectors/vectors.control /opt/bitnami/postgresql/share/extension/ \
    && rm -rf /tmp/vectors /tmp/vectors.zip

# 5. Install VectorChord (The feature from the first script)
RUN wget -nv -O /tmp/vchord.deb https://github.com/tensorchord/VectorChord/releases/download/$VECTORCHORD_TAG/postgresql-${PG_MAJOR}-vchord_${VECTORCHORD_TAG#"v"}-1_${TARGETARCH}.deb \
    && apt-get update && apt-get install -y /tmp/vchord.deb \
    && rm -f /tmp/vchord.deb

# 6. Configure Bitnami to load these libraries
# Bitnami uses 'postgresql.conf' - we need to ensure these extensions are preloaded
RUN sed -i "s/^#shared_preload_libraries = .*/shared_preload_libraries = 'vectors.so, vchord.so'/" /opt/bitnami/postgresql/conf/postgresql.conf || \
    echo "shared_preload_libraries = 'vectors.so, vchord.so'" >> /opt/bitnami/postgresql/conf/postgresql.conf

# 7. Switch back to Bitnami default user
USER 1001