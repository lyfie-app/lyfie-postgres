FROM postgres:16

# Install only the necessary tools to download and extract the extension
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Download and install pgvecto.rs extension
# Using dynamic paths with pg_config to ensure compatibility
RUN wget https://github.com/tensorchord/pgvecto.rs/releases/download/v0.2.1/vectors-pg16_x86_64-unknown-linux-gnu_0.2.1.zip -O vectors.zip \
    && unzip vectors.zip -d vectors \
    && cp vectors/vectors.so $(pg_config --pkglibdir) \
    && cp vectors/vectors--* $(pg_config --sharedir)/extension/ \
    && cp vectors/vectors.control $(pg_config --sharedir)/extension/ \
    && rm -rf vectors vectors.zip
