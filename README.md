# OpenEMPI 3.5.0c + OrientDB — Entorno Docker

Despliegue contenerizado de OpenEMPI 3.5.0c con OrientDB como base de datos de grafos para la gestión de enlaces de matching.

## Arquitectura

```
┌─────────────────────────────────────────┐
│           Docker Compose                │
│                                         │
│  ┌──────────────┐   ┌────────────────┐  │
│  │   openempi   │──▶│   orientdb     │  │
│  │  Tomcat 8    │   │   v2.2.17      │  │
│  │  JDK 8       │   │                │  │
│  │  H2 (embed.) │   │                │  │
│  └──────────────┘   └────────────────┘  │
│   :8080                :2424 / :2480    │
└─────────────────────────────────────────┘
```

- **openempi**: Tomcat 8 + OpenEMPI 3.5.0c sobre Ubuntu 20.04 con JDK 8. Usa H2 como base de datos relacional embebida.
- **orientdb**: OrientDB 2.2.17 para la persistencia de los enlaces de matching.

## Requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado y en ejecución.
- No se requiere ninguna instalación adicional.

## Instalación rápida

**1. Descarga el ZIP completo** desde la sección [Releases](../../releases) de este repositorio.

**2. Descomprime** en cualquier carpeta, por ejemplo `C:\docker-openempi\`

**3. Arranca los contenedores:**
```powershell
cd C:\docker-openempi
docker compose up -d
```

**4. Accede a OpenEMPI** en el navegador:
```
http://localhost:8080/openempi-admin
```
Credenciales: `admin` / `admin`

**5. Accede a la consola de OrientDB** (opcional):
```
http://localhost:2480
```
Credenciales: `root` / `openempi`

---

## Estructura del proyecto

```
docker-openempi/
├── docker-compose.yml          ← orquestación de los servicios
├── .gitignore
├── README.md
├── openempi/
│   ├── Dockerfile
│   ├── entrypoint.sh
│   └── app/                    ← instalación de OpenEMPI (incluida en el ZIP del release)
├── orientdb/
    ├── Dockerfile
    ├── entrypoint.sh
    └── app/                    ← instalación de OrientDB (incluida en el ZIP del release)
```

## Comandos útiles

```powershell
# Ver estado de los contenedores
docker compose ps

# Ver logs en tiempo real
docker compose logs -f

# Ver logs de un servicio concreto
docker compose logs -f openempi
docker compose logs -f orientdb

# Parar los servicios (sin borrar datos)
docker compose down

# Parar y borrar todos los datos
docker compose down -v

# Reiniciar un servicio
docker compose restart openempi

# Entrar a la shell de un contenedor
docker compose exec openempi bash
docker compose exec orientdb bash
```

## Persistencia de datos

Los datos se guardan en volúmenes Docker con nombre que sobreviven a reinicios:

| Volumen | Contenido |
|---------|-----------|
| `docker-openempi_orientdb_databases` | Bases de datos de OrientDB (enlaces de matching) |
| `docker-openempi_orientdb_backup` | Backups de OrientDB |
| `docker-openempi_openempi_logs` | Logs de la aplicación |


## Solución de problemas

### El contenedor openempi no arranca
```powershell
docker compose logs openempi
```

### OrientDB no acepta conexiones
Espera 15-20 segundos tras el arranque. OrientDB tarda en inicializarse.

### Puerto 8080 ya en uso
Cambia el puerto en `docker-compose.yml`:
```yaml
ports:
  - "9090:8080"
```

---

## Tecnologías utilizadas

- Docker / Docker Compose
- OpenEMPI 3.5.0c
- Apache Tomcat 8.0.44
- OrientDB 2.2.17
- H2 Database (embebida)
- Ubuntu 20.04
- OpenJDK 8
