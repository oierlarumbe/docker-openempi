# ============================================================
# OrientDB – Dockerfile
# Empaqueta tu instalación local de OrientDB
# ============================================================
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    curl \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

RUN useradd -m -s /bin/bash orientdb
WORKDIR /opt/orientdb

# --- Copiar la instalación local de OrientDB ---
# El contenido de tu carpeta orientdb de Windows va aquí como "app"
COPY app/ /opt/orientdb/

RUN chmod +x /opt/orientdb/bin/*.sh 2>/dev/null || true
RUN chown -R orientdb:orientdb /opt/orientdb

# Puertos de OrientDB:
#  2424 = protocolo binario (usado por OpenEMPI)
#  2480 = consola web HTTP
EXPOSE 2424 2480

# Persistencia de datos
VOLUME ["/opt/orientdb/databases"]

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER orientdb
ENTRYPOINT ["/entrypoint.sh"]
