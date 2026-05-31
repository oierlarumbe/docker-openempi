# ============================================================
# OpenEMPI 3.5.0c – Dockerfile
# Basado en Ubuntu 20.04 + JDK 8 (requerido por OpenEMPI 3.x)
# ============================================================
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# --- Java 8 (OpenEMPI 3.x requiere JDK 8) ---
RUN apt-get update && apt-get install -y \
    openjdk-8-jdk \
    curl \
    wget \
    unzip \
    net-tools \
    iputils-ping \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$JAVA_HOME/bin:$PATH"

# --- Crear usuario y directorio de trabajo ---
RUN useradd -m -s /bin/bash openempi
WORKDIR /opt/openempi

# --- Copiar la instalación local de OpenEMPI ---
# IMPORTANTE: ejecutar desde el directorio docker-openempi/
# La carpeta openempi de Windows debe estar copiada como "app" aquí
COPY app/ /opt/openempi/

# --- Permisos de ejecución ---
RUN chmod +x /opt/openempi/bin/*.sh 2>/dev/null || true
RUN chown -R openempi:openempi /opt/openempi

# --- Puerto de OpenEMPI (web console + REST API) ---
EXPOSE 8080

# --- Variables de entorno para base de datos ---
# Se pueden sobreescribir en docker-compose.yml
ENV OPENEMPI_DB_HOST=postgres
ENV OPENEMPI_DB_PORT=5432
ENV OPENEMPI_DB_NAME=openempi
ENV OPENEMPI_DB_USER=openempi
ENV OPENEMPI_DB_PASSWORD=openempi

# --- Script de arranque ---
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER openempi
ENTRYPOINT ["/entrypoint.sh"]
