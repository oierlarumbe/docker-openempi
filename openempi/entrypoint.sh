#!/bin/bash
# ============================================================
# Entrypoint de OpenEMPI
# Espera a que OrientDB esté listo antes de arrancar
# OpenEMPI usa H2 como base de datos relacional embebida
# ============================================================

set -e

echo "=========================================="
echo "  OpenEMPI 3.5.0c - Iniciando contenedor"
echo "=========================================="

# --- Función: esperar a que un host:puerto esté disponible ---
wait_for() {
    local host=$1
    local port=$2
    local service=$3
    echo "Esperando a $service ($host:$port)..."
    while ! (echo > /dev/tcp/$host/$port) 2>/dev/null; do
        echo "  $service no disponible todavía, reintentando en 3s..."
        sleep 3
    done
    echo "  $service disponible."
}

# Esperar a OrientDB (puerto binario)
wait_for "orientdb" "2424" "OrientDB"

echo ""
echo "Arrancando OpenEMPI (Tomcat en primer plano)..."
echo "Consola disponible en http://localhost:8080/openempi-admin"
echo ""

# catalina.sh run mantiene el proceso en primer plano
# (startup.sh lanza Tomcat en background y mata el contenedor)
exec /opt/openempi/bin/catalina.sh run
