#!/bin/bash
# ============================================================
# Entrypoint de OrientDB
# ============================================================

set -e

echo "=========================================="
echo "  OrientDB - Iniciando contenedor"
echo "=========================================="

# Buscar el script de arranque
if [ -f "/opt/orientdb/bin/server.sh" ]; then
    echo "Arrancando OrientDB con bin/server.sh..."
    exec /opt/orientdb/bin/server.sh
elif [ -f "/opt/orientdb/server.sh" ]; then
    exec /opt/orientdb/server.sh
else
    echo "ERROR: No se encontró bin/server.sh en /opt/orientdb"
    echo "Contenido de /opt/orientdb:"
    ls -la /opt/orientdb/
    exit 1
fi
