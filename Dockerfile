FROM bitnami/postgresql-repmgr:16.3.0

# Switch to root to use apt
USER root

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    gnupg2 \
    wget \
    lsb-release \
    unzip \
    software-properties-common

# Download and build pgvector extension
RUN wget https://github.com/tensorchord/pgvecto.rs/releases/download/v0.2.1/vectors-pg16_x86_64-unknown-linux-gnu_0.2.1.zip -O vectors.zip \
    && unzip vectors.zip -d vectors \
    && cp vectors/vectors.so /opt/bitnami/postgresql/lib/ \
    && cp vectors/vectors--* /opt/bitnami/postgresql/share/extension/ \
    && cp vectors/vectors.control /opt/bitnami/postgresql/share/extension/

USER 1001
